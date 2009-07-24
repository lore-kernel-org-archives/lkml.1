Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZGXPl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZGXPl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZGXPl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:41:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:19361 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZGXPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e+rcG2XYlGp0DAYx0tTPzCRDW2uUBW61hF1iUyeqUVqhYY+w81F/jt95eAYkq8sGiK
         qoMNHotjFkhSklRehA6MisRGSl6TiCIKY1cVFIb7cDTvBbsggLYR4i/nokSpJ8fovWcF
         RU6DyPQbR3RYSraeDqLWPmsEi1/dOa6KNNPGw=
MIME-Version: 1.0
In-Reply-To: <20090723150517.fbbd03dc.akpm@linux-foundation.org>
References: <200907191659.47179.czoccolo@gmail.com>
	 <20090723150517.fbbd03dc.akpm@linux-foundation.org>
Date: Fri, 24 Jul 2009 17:41:26 +0200
Message-ID: <4e5e476b0907240841y183a4c08r3abf3d4fb7489284@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: menu governor: reduce latency on exit
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: venkatesh.pallipadi@intel.com, abelay@novell.com,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
the expected effect is to reduce processor wakeup latency from sleep (C-states).

We are speaking of few hundreds of cycles reduction out of a several
microseconds latency (determined by the hardware transition), so it is
difficult to measure.

Corrado

On Fri, Jul 24, 2009 at 12:05 AM, Andrew
Morton<akpm@linux-foundation.org> wrote:
> On Sun, 19 Jul 2009 16:59:46 +0200
> Corrado Zoccolo <czoccolo@gmail.com> wrote:
>
>> This patch moves the state residency accounting and statistics
>> computation off the hot exit path.
>> On exit, the need to recompute statistics is recorded, and new
>> statistics will be computed when menu_select is called again.
>>
>
> Was there any observed and/or measured effect as a result of this patch?
>
> If so, please send a description of that effect, thanks.
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
