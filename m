Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYEQShA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYEQShA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYEQSgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:36:52 -0400
Received: from pat.uio.no ([129.240.10.15]:44240 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYEQSgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:36:51 -0400
Subject: Re: Solved - How to change the FSINFO for nfsd?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "P.V.Anthony" <pvantony@singnet.com.sg>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0805172024440.15590@fbirervta.pbzchgretzou.qr>
References: <482332CD.4010706@singnet.com.sg>
	 <20080509042238.GC21408@fieldses.org>
	 <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg>
	 <alpine.LNX.1.10.0805172024440.15590@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Sat, 17 May 2008 14:36:42 -0400
Message-Id: <1211049402.7498.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: BBB687B4E47FAF3E11C1411BF1CF3FB17CC0EB74
X-UiO-SR-test: BFD96B7B45FE1D3AC4A3A77F3481E55470E1C22C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 121 total 8444416 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-17 at 20:25 +0200, Jan Engelhardt wrote:
> On Saturday 2008-05-17 19:57, P.V.Anthony wrote:
> > resp->f_properties = NFS3_FSF_DEFAULT;
> >
> > nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
> > @@ -570,7 +570,7 @@
> > if (sb->s_magic == 0x4d44 /* MSDOS_SUPER_MAGIC */) {
> > resp->f_properties = NFS3_FSF_BILLYBOY;
> > }
> > - resp->f_maxfilesize = sb->s_maxbytes;
> > + resp->f_maxfilesize = 0xffffffffffffffff;

   This is plain wrong! Pretending that your filesystem supports 64-bit
files won't magically make it so.

Trond

