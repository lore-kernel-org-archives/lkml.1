Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbXGYNfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbXGYNfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbXGYNfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:35:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275AbXGYNfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:35:30 -0400
Message-ID: <46A7519A.20108@redhat.com>
Date: Wed, 25 Jul 2007 09:35:22 -0400
From: Chris Lalancette <clalance@redhat.com>
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]: Add command-line option to i8042 to completely disable
 it
References: <46A4DFD2.2010501@redhat.com> <20070725000504.f8ce49c1.akpm@linux-foundation.org> <20070725080355.GA14726@suse.cz>
In-Reply-To: <20070725080355.GA14726@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik wrote:
>>
>>That's an unfortunate fix.  Is there really no way in which we
>>can auto-detect such a situation without requiring a manual
>>setting?
> 
> 
> The fact that the current detection hangs suggests that the scenario is
> possible to detect.
> 

Hm, OK.  I'll go back and look at i8042_flush() to see if I can detect this
erroneous situation automatically and fail the i8042_controller_init() if I see it.

Chris Lalancette
