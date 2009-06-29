Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZF2F7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZF2F7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 01:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZF2F7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 01:59:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:44797 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZF2F7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 01:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j6LVui8By5raTZ0sMZ0OEHxWlT1AyCoXL814WeV7JNvX6Q/Naqzo4lc29fzoA3rc0W
         Hb/MXW8mMtduB3+gaOBvunb3LqCdi1rPYLw1aOtmljFwoi+SmnbAXBIf48uKMjWDFLWN
         eZ85Y97oujtFkDE88Fbi5pBFSdxv71XxdhPjI=
Date: Sun, 28 Jun 2009 22:59:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: alek.du@intel.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, soni.trilok@gmail.com, ben-linux@fluff.org,
       ext-phil.2.carmody@nokia.com
Subject: Re: [PATCH 0/2] fix gpio-keys debouncing and timer sleep issues
Message-ID: <20090629055940.GC12821@dtor-d630.eng.vmware.com>
References: <20090626002345.07928230@dxy.sh.intel.com> <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jani,

On Fri, Jun 26, 2009 at 03:15:16PM +0300, Jani Nikula wrote:
> Alek, someone might depend on how debouncing worked before, so let's not 
> break it. I, for one, am looking at using this in the future, and would 
> want this to work as it was before.
> 
> Why don't we fix this instead of debating? For simplicity, here's first 
> a revert of the original patch and then a fix to the sleep issue. 
> Unfortunately, I do not have the equipment to properly test this right 
> now.
> 

I intend to apply the both patches. It is unfortunate that we need to
use both a timer and a workqueue, I wonder what would it take to
implement something like reschedule_delayed_work() that would adjust
the delay in the same fashion that mod_timer() does?

-- 
Dmitry
