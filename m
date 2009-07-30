Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbZG3Rws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbZG3Rws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZG3Rwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:52:47 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:36215 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZG3Rwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:52:46 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [RFC] Uni-processor interrupt state preservation.
Date: Thu, 30 Jul 2009 12:51:44 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200907301137.22035.lkml@morethan.org> <200907301201.12197.lkml@morethan.org> <ada7hxqrt3h.fsf@cisco.com>
In-Reply-To: <ada7hxqrt3h.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907301251.46635.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu July 30 2009, Roland Dreier wrote:
> 
>  > If it does, then that is the answer to my question -
>  > Link to the ABI document please.
> 
> www.sco.com/developers/devspecs/abi386-4.pdf:
> 
>    Registers %ebp, %ebx, %edi, %esi, and %esp ‘‘belong’’ to the cal-
>    ling function. In other words, a called function must preserve these
>    registers’ values for its caller.
> 
> 

Super!

Should not be too big a job to make sure that is indeed happening as expected.
Most uses of this function dispatcher are not built in Uni-processor builds.
Only a small handful of references.

Thanks,
Mike
