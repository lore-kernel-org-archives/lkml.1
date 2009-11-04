Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZKDUQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZKDUQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbZKDUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:16:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:52119 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133AbZKDUQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RnH9EfGDcqz3AvSE/saph1MRwqNE9X+tEsjjF03FUS0gTLaOsrL5ymto6/Xf+DAjBQ
         xOzuHVUYPomUMpTxDljBXVZ41SIoIepqP5pXHeeUDZC7ycnfGrWMSCN6MPSPRNlRCIfn
         SaMhvep4gKZt8PI0YoU73Cpd4sQepnqxPKTCM=
Message-ID: <4AF1E11F.6000404@gmail.com>
Date: Wed, 04 Nov 2009 21:16:31 +0100
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: no video output after suspend after "drm/i915: force mode set
 at lid open time"
References: <4AE4BBBC.2070809@gmail.com>	<20091026090548.2d4e20a9@jbarnes-g45>	<4AE76463.6010404@gmail.com>	<20091027142609.73ac95e2@jbarnes-g45>	<4AEC3ED7.6010003@gmail.com>	<4AEC3FC3.3090209@gmail.com> <20091104111958.1b9c738e@jbarnes-piketon>
In-Reply-To: <20091104111958.1b9c738e@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes ha scritto:
> On Sat, 31 Oct 2009 14:46:43 +0100
> Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
>>> Sorry for taking so long to respond. Anyway latest Linus' git
>>> master with reverted c1c7af60892070e4b82ad63bbfb95ae745056de0 , per
>>> attached patch, does not fix the issue for me. Please note that
>>> just reverting the commit does not compile because of an added user
>>> of acpi_lid_open() which requires acpi/button.h which has been
>>> added in 7121413f2accf14cf05b38539fb7a8be77543370. Will try to
>>> revert that too.
>> Sorry, that commit just change that line, it does not add the 
>> acpi_lid_open() call.
> 
> Linus's tree has another change which might help:
> 
> commit c9354c85c1c7bac788ce57d3c17f2016c1c45b1d
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Nov 2 09:29:55 2009 -0800
> 
>     i915: fix intel graphics suspend breakage due to resume/lid event
>     confusion
> 
> Have you tried a tree with it included yet?

Sure, i tested 2.6.32-rc6 and latest Linus' git 
91d3f9bacdb4950d2f79fe2ba296aa249f60d06c which has latest pull from drm 
tree.

Btw, does anybody know how to update bugzilla by email? Can't find it 
mentioned anywhere.

thanks,
riccardo
