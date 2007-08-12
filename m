Return-Path: <linux-kernel-owner+w=401wt.eu-S937663AbXHLTF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937663AbXHLTF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935521AbXHLTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:05:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:41005 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935275AbXHLTFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P4fCOu3mFPRotmS3CHeqNEjC22V8WMtD8E9GJsW5KYs06qmvM8R4Dr5LB0vSvE3h11rDsS21xVYdkEomCxjMbQF4KrLyHU9AwfhaAREKGeKX5QolMs3E2DsR3Mh4XX3yVzAFI+L+oId6z6ktOwRl/uw8qmKUj4UAVfMFevIr1zo=
Message-ID: <66dc75180708121205q5e90958u4f3eed9b788faf07@mail.gmail.com>
Date: Sun, 12 Aug 2007 15:05:46 -0400
From: chibiryuu <ephemient@gmail.com>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: Software based ECC ?
Cc: Valdis.Kletnieks@vt.edu, roland <devzero@web.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070812165131.GG7973@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <000a01c7db93$c75b66c0$eeeea8c0@aldipc>
	 <12507.1186812675@turing-police.cc.vt.edu>
	 <20070812165131.GG7973@vanheusden.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> > > http://pdos.csail.mit.edu/papers/softecc:ddopson-meng/softecc_ddopson-meng.pdf
> > > "SoftECC : A System for Software Memory Integrity Checking"
> >
> > Personally, I'd recommend just shelling out the bucks for hardware ECC if
> > the reliability matters.
>
> a question and an idea: Q: is ecc guaranteed to detect all bitflips?
>
> Idea: what about a multicore system (3 or more) that runs the same
> processes on 2 cores and a third core verifying that they both do the
> same? As I think it is not only ram that can become faulty.

Such hardware does exist -- for example, Stratus sells systems that
run the same OS on two separate boards in lockstep, with a voter to
determine what action to take if they ever diverge.
