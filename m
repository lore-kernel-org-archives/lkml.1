Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZJ3Tlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZJ3Tlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbZJ3Tlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:41:36 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:55557 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbZJ3Tlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:41:35 -0400
X-Greylist: delayed 2251 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2009 15:41:35 EDT
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200910291936.14082.rjw@sisk.pl>
	<87fx91q1bc.fsf@tac.ki.iif.hu> <200910301918.53301.rjw@sisk.pl>
Date: Fri, 30 Oct 2009 20:03:50 +0100
In-Reply-To: <200910301918.53301.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 30 Oct 2009 19:18:53 +0100")
Message-ID: <87k4yc3drd.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Thursday 29 October 2009, Ferenc Wagner wrote:
>
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>>> Which part of it is getting slower?  Saving the image, suspending
>>> devices or the entire hibernation overall?
>> 
>> "Snapshotting system" before saving the image
>
> That may be a result of changing the way in which image memory is reserved.
> How much memory is there in your machine?

512 MB.

>> and saving the image as well.  If s2disk didn't report funny huge negative
>> ratios all the time,
>
> Hmm.  This looks like a bug in s2disk.

Definitely.  Do you also experience this?  Probably an easy one, but
I've never had the chance to check the CVS version (running 0.7 at the
moment).  I can probably give 0.8 a spin if you deem necessary.  I
always thought it wasn't more than a cosmetic flaw.
-- 
Thanks,
Feri.
