Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbZLKThF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbZLKThF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761133AbZLKThA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:37:00 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:17932
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761571AbZLKTg7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:36:59 -0500
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371P103dKzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KUI4WC-01-NFJ-02
X-M-MSG: 
Date: Fri, 11 Dec 2009 20:02:42 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Aristeu Rozanski <aris@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: Re: [PATCH v2] x86, msr: add support for non-contiguous cpumasks
Message-ID: <20091211190242.GA25195@aftab>
References: <20091207122133.GA24877@aftab>
 <4B21A50E.5090801@zytor.com>
 <20091211171440.GD31998@aftab>
 <4B228902.7010609@zytor.com>
 <20091211183635.GE31998@aftab>
 <4B229351.3030405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4B229351.3030405@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Dec 2009 19:02:38.0226 (UTC) FILETIME=[81A45720:01CA7A94]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:45:37AM -0800, H. Peter Anvin wrote:
> On 12/11/2009 10:36 AM, Borislav Petkov wrote:
> > On Fri, Dec 11, 2009 at 10:01:38AM -0800, H. Peter Anvin wrote:
> >> On 12/11/2009 09:14 AM, Borislav Petkov wrote:
> >>> Ok, here's a second (and much leaner, removing a bunch of code) version.
> >>> Tested on K8 and F10h machines here.
> >>
> >> Much better, thanks!
> > 
> > Ok, cool. Should I send it to Linus or would you like to do it?
> > 
> 
> I am just in the process of putting it into -tip, but if you prefer to
> send it directly you can have my
> 
> 	Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> Whichever way is easier for you is fine with me.

I doesn't matter to me either. It touches x86-related code, so it makes
sense to go through you, besides you've already started it :).

My only concern is that it should go in now since it got caught couple
of days before 2.6.32 got released. A proper fix wouldn't have made it
in at that late in the release cycle (-rc8), therefore, I'll be at least
able to backport it now as soon as it hits mainline so that at least
2.6.32.2 has the proper fix.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

