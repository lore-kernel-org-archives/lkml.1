Return-Path: <linux-kernel-owner+w=401wt.eu-S1765954AbYETNMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765954AbYETNMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYETNMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:12:17 -0400
Received: from pat.uio.no ([129.240.10.15]:35789 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbYETNMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:12:16 -0400
Subject: Re: Solved - How to change the FSINFO for nfsd?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "P.V.Anthony" <pvantony@singnet.com.sg>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
In-Reply-To: <483288B1.3060102@singnet.com.sg>
References: <482332CD.4010706@singnet.com.sg>
	 <20080509042238.GC21408@fieldses.org>
	 <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg>
	 <alpine.LNX.1.10.0805172024440.15590@fbirervta.pbzchgretzou.qr>
	 <1211049402.7498.4.camel@localhost> <20080519172412.GL7622@fieldses.org>
	 <483288B1.3060102@singnet.com.sg>
Content-Type: text/plain
Date: Tue, 20 May 2008 09:12:08 -0400
Message-Id: <1211289128.13163.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: ABC18F035D87D7D9C0B23AEBCF65534F3D508A03
X-UiO-SR-test: 7181F8C3FC50B8DF91EB5FF900460FBDD60F2D69
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 448 total 8491235 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 16:15 +0800, P.V.Anthony wrote:
> Using xfs filesystem on a gentoo 64bit linux with 2.6.22 kernel,
> when mounting the FSINFO return got was 7f ff ff ff ff ff ff ff.
> 
> Assuming that xfs is 64bit,
> the FSINFO returned is still not ff ff ff ff ff ff ff ff.
> 
> Used wireshark to see the FSINFO return.
> 
> P.V.Anthony

XFS is 64-bit, but file sizes are of type off_t or loff_t, and are
therefore _signed_.
0x7fffffffffffffff is therefore indeed the maximum allowed file size for
a 64-bit filesystem.

Trond

