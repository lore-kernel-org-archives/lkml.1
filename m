Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZCCRC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZCCRC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 12:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZCCRCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 12:02:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZCCRCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:02:51 -0500
Date: Tue, 3 Mar 2009 12:02:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Felix Blyakher <felixb@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: next-20090220: XFS: inconsistent lock state
Message-ID: <20090303170248.GA7036@infradead.org>
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com> <20090224200740.GA9266@infradead.org> <49AD5401.30803@sandeen.net> <A277CB1C-4258-42EC-B1D9-F5CAAB962B42@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A277CB1C-4258-42EC-B1D9-F5CAAB962B42@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 10:57:07AM -0600, Felix Blyakher wrote:
> 	if (lock_flags) {
> 		if (!xfs_ilock_nowait(ip, lock_flags)) {
> 			ASSERT(0);
> 			error = EAGAIN;
> 			goto out_destroy;
> 		}
> 	}
> 				
> Or just keep the BUG(); , as it shouldn't happen (we hope).

Ok, let's keep the BUG for now and I'll throw in your error undwinding
fix.  Will resend the series for 2.6.29 patches after QAing them.

