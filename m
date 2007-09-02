Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbXIBVFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbXIBVFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXIBVFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:05:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:31752 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbXIBVFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VjcPjhyHyVlVDKvW3A1uSHiZmSdasdaswuMh4xtrPpPCfId5tjnZL+G0gPmMdfLJYH5ZeYOkptCgCdHEPaeeyzwmXbtTVRD1wxFAUic+bJp+MHxAFDXcXfLmvKpeqQPh5n15pIGnIxZ12ui+YsK4iOd5HtTJu2LOqaWYM69uyX4=
Message-ID: <68676e00709021405i70faca8bs910a988a67adb49d@mail.gmail.com>
Date: Sun, 2 Sep 2007 23:05:06 +0200
From: Luca <kronos.it@gmail.com>
To: "Prakash Punnoor" <prakash@punnoor.de>
Subject: Re: ipv4_get_l4proto: Frag of proto 17
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709020955.31420.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709020955.31420.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, Prakash Punnoor <prakash@punnoor.de> wrote:
> Hi,
>
> since 2.6.23-rc1 my log gets cluttered with
>
> ipv4_get_l4proto: Frag of proto 17
>
> What is the reason?

netfilter conntrack code. See:
http://article.gmane.org/gmane.linux.network/70824

Luca
