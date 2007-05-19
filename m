Return-Path: <linux-kernel-owner+w=401wt.eu-S1764483AbXESUXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764483AbXESUXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761078AbXESUWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:22:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:37414 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026AbXESUWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qa5cG4qTkbqKy4zi3HhN9wCKkTKYk926X3Cm9tV6ZevjgoBQQesaWf+UnbLV2BrCLlIiSVcMmoNPgLv0DpKeTPTtn7R/XV+aMtQZzzGPpPAIHuVuNJZ1uibOhQ1X8ZNUutihcskQFOARFcXAad6keorM0tDAr53lD3bluWAuIg0=
Message-ID: <2c0942db0705191322p54e05e40p512146f21f68299a@mail.gmail.com>
Date: Sat, 19 May 2007 13:22:43 -0700
From: "Ray Lee" <ray@madrabbit.org>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Cc: "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
In-Reply-To: <464F57DD.2000309@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F57DD.2000309@tmr.com>
X-Google-Sender-Auth: 3ac4d294fd39fa0d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Bill Davidsen <davidsen@tmr.com> wrote:
> I generated a table of results from the latest glitch1 script, using an
> HTML postprocessor I not *quite* ready to foist on the word. In any case
> it has some numbers for frames per second, fairness of the processor
> time allocated to the compute bound processes which generate a lot of
> other screen activity for X, and my subjective comments on how smooth it
> looked and felt.
>
> The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for
> your viewing pleasure.

Is the S.D. columns (immediately after the average) standard
deviation? If so, you may want to rename those 'stdev', as it's a
little confusing to have S.D. stand for that and Staircase Deadline.
Further, which standard deviation is it? (The standard deviation of
the values (stdev), or the standard deviation of the mean (sdom)?)

Finally, if it is the standard deviation (of either), then I don't
really believe those numbers for the glxgears case. The deviation is
huge for all but one of those results.

Regardless, it's good that you're doing measurements, and keep it up :-).
