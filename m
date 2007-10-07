Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbXJGLD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbXJGLD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 07:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXJGLDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 07:03:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57655 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbXJGLDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 07:03:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 8/9] compat_ioctl: call disk->fops->compat_ioctl without BKL
Date: Sun, 7 Oct 2007 13:02:15 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, hch@lst.de
References: <20071006181902.141862534@arndb.de> <20071006182343.694115455@arndb.de> <20071007095348.GQ8181@ftp.linux.org.uk>
In-Reply-To: <20071007095348.GQ8181@ftp.linux.org.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071302.15827.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18f+0NLe1qYnlNQImjxVFhwHnyqob3+/3e3Bon
 iCT4Icgx+yXs42rq3gEhT9ZvzQgx/lGaCiSVLE3+4LQtSUIu7F
 aatHNTc1JtUefbtsM14og==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2007, Al Viro wrote:
> On Sat, Oct 06, 2007 at 08:19:10PM +0200, Arnd Bergmann wrote:

> > It would be good to find out whether it has been using the BKL
> > on purpose or by accident, before this patch gets applied.
> 
> Leave it alone, for now - I'm rebasing my series on top of your 1--7
> and it will both makes ->ioctl() and ->compat_ioctl() called unlocked
> and switches ->compat_ioctl() to passing bdev instead of struct file
> (->unlocked_ioctl() simply dies).

ok, excellent.

	Arnd <><
