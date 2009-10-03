Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZJCOiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZJCOiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZJCOiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:38:10 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:40540 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZJCOiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MmZ4SJAriPwxp2Cl65uXGY+gL3fyC86JgPFMP0j9MQfyV+FJzv17dVC7+zdcCQyuWE
         YPrkumvi5SQuZSsuU5HWEr43Id6wWmQce7K/a0sMZ9ZuD2sJ5uokW+hzT6oN2XpMugwY
         OsTp0xNym7d0j54bw7DweNhq18MnBbC6ZnYi4=
MIME-Version: 1.0
In-Reply-To: <20091003121958.GD32486@mea-ext.zmailer.org>
References: <20091003121958.GD32486@mea-ext.zmailer.org>
Date: Sat, 3 Oct 2009 10:38:12 -0400
Message-ID: <a728f9f90910030738q4341611fm4ccd680b51201f6d@mail.gmail.com>
Subject: Re: How to disable drm/kms actions during boot?
From: Alex Deucher <alexdeucher@gmail.com>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 8:19 AM, Matti Aarnio <matti.aarnio@zmailer.org> wrote:
> I have a display card + display combination that has recently had much problems
> during system boot.  Some system versions boot just fine to very large text mode,
> others create entirely black display.
>
> Is there any way to forbid the DRM from doing "maximize the text display area"
> operation at all during the boot?  I do want the DRM/KMS to happen latter, but
> NOT during system boot!
>

Boot with nomodeset or radeon.modeset=0 on the kernel command line.
That will disable kernel modesetting at boot.  You can then manually
load the modules with or without modesetting once the system is
booted.  drm-next also recently got support for forcing the console
mode.

Alex
