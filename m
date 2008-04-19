Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbYDSGR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbYDSGR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbYDSGRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:17:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:37997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbYDSGRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aW9u5DkBbkVoYoBtQmjG+LRPrnkIbU1WMzL4lKLeU6vgg32Q/Xhx0AzS3WTmalNV9D4BRLWcQsq5bMoau49o2rEEiIaWDOOIVO8s5G4RTII26ett9NA7ti8YQqXX5tdyY34k6/nUWvIDyVuMkdnOPbbURI7Tlr01m0vKlxGWOQE=
Date: Sat, 19 Apr 2008 10:17:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew <jackdachef@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25
Message-ID: <20080419061701.GA7688@cvg>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org> <20080418193802.GK7674@cvg> <20080418200338.GL7674@cvg> <48096179.4060803@keyaccess.nl> <480964F7.3040701@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480964F7.3040701@keyaccess.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rene Herman - Sat, Apr 19, 2008 at 05:20:23AM +0200]
> On 19-04-08 05:05, Rene Herman wrote:
>> On 18-04-08 22:03, Cyrill Gorcunov wrote:
>>> | it seems drivers/acpi/thermal.c has a small nit
>>> | | 881:    /* sys I/F for generic thermal sysfs support */
>>> | 882:    #define KELVIN_TO_MILLICELSIUS(t) (t * 100 - 273200)
>>> | | but it should multiply by 1000 meguess
>>> |
>>> oh, i'm wrong, sorry
>> ? How are you wrong ?
>
> (okay, it's only the name which is wrong; it's DECIKELVIN_TO_MILLICELSIUS)
>
> Rene.
>

yep, I was confused by these names too ;)

		- Cyrill -
