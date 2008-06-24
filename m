Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYFXJ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYFXJ2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYFXJ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:28:20 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37929 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbYFXJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:28:10 -0400
Message-ID: <4860BE4B.10100@keyaccess.nl>
Date: Tue, 24 Jun 2008 11:28:43 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Zhang Rui <rui.zhang@intel.com>,
       linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors
 2  userspace
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no>	<fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no>	<48605935.5070407@shaw.ca>	<alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org> <20080624085940.3ee3bf77@hyperion.delvare>
In-Reply-To: <20080624085940.3ee3bf77@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-06-08 08:59, Jean Delvare wrote:

> On Mon, 23 Jun 2008 20:07:15 -0700 (PDT), Linus Torvalds wrote:
>> On Mon, 23 Jun 2008, Robert Hancock wrote:
>>> Mark M. Hoffman wrote:
>>>> 2) This patch is broken.
>>> You didn't indicate what was wrong with the patch.
>> Yes. Leaving everybody wondering whether it's just an opinionated 
>> expression of the former problem, or whether there is a real and 
>> understandable reason why it was NACK'ed.
> 
> I guess Mark assumed that everybody had read the discussion thread Rene
> referenced, where I explained why his patch was broken:
> 
> http://lkml.org/lkml/2008/6/23/175

You could've known that he himself didn't because in that same thread I 
explained to you why it wasn't broken in actual real life.

That said, I agree that with the issue of multiple thermal zones sharing 
a single hwmon interface (as also indicated in the changelog) it's not a 
nice solution. Len Brown also indicated that the "make it optional" 
patch (originally nacked as ugly by Hans, which was the only reason I 
tried getting you people something else again...) that I saw Zhang Rui 
repost just now would be better than that.

And, as said, now that lm-sensors 2.10.7 is close, I don't actually 
think it's a huge deal anymore anyway. The breakage is still pretty 
unfortunate, but that one should be painless enough as an upgrade to 
shrug this off really. It was the upgrade path to 3.x which would've 
been much too painful to have this done without any prior warning.

So we're waiting for 2.10.7 now.

Rene.
