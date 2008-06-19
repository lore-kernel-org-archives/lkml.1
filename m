Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYFSFBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYFSFBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYFSFBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:01:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47976 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbYFSFBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:01:44 -0400
Date: Thu, 19 Jun 2008 06:01:42 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] agp patches for 2.6.26 final
In-Reply-To: <alpine.LFD.1.10.0806182153140.2907@woody.linux-foundation.org>
Message-ID: <alpine.DEB.0.82.0806190557280.14089@skynet.skynet.ie>
References: <alpine.DEB.0.82.0806190538490.14089@skynet.skynet.ie>
 <alpine.LFD.1.10.0806182153140.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-445143999-1213851702=:14089"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-445143999-1213851702=:14089
Content-Type: TEXT/PLAIN; charset=US-ASCII

> On Thu, 19 Jun 2008, Dave Airlie wrote:
> > 
> > commit 62c96b9d0917894c164aa3e474a3ff3bca1554ae
> > Author: Dave Airlie <airlied@redhat.com>
> > Date:   Thu Jun 19 14:27:53 2008 +1000
> > 
> >     agp/intel: cleanup some serious whitespace badness
> >     
> >     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> Aarghh!
> 
> This one does _not_ just clean up whitespace. It also does
> 
> 	@@ -1959,8 +1959,6 @@ static const struct agp_bridge_driver intel_i965_driver = {
> 	 	.size_type		= FIXED_APER_SIZE,
> 	 	.num_aperture_sizes	= 4,
> 	 	.needs_scratch_page	= true,
> 	-	.configure		= intel_i915_configure,
> 	-	.fetch_size		= intel_i9xx_fetch_size,
> 	 	.cleanup		= intel_i915_cleanup,
> 	 	.tlb_flush		= intel_i810_tlbflush,
> 	 	.mask_memory		= intel_i965_mask_memory,
> 
> which may well be all good, but it doesn't match the commit message.
> 
> I merged it, but please be more careful.
> 

DAMNIT.

I can't believe that happened, I going to stop doing whitespace cleanups 
now, I just got shocked when I realised how much 7 space indents that file 
has.

You are right please put back the two lines as per the attached patch.

Dave.
--29444707-445143999-1213851702=:14089
Content-Type: TEXT/x-diff; charset=US-ASCII; name=test.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.82.0806190601420.14089@skynet.skynet.ie>
Content-Description: 
Content-Disposition: attachment; filename=test.patch

Y29tbWl0IDBlNDgwZTVmYzAzYzQxMWQzNTA0NzhiMmU4ZGMwOTA2YTM3YjZm
MDcNCkF1dGhvcjogRGF2ZSBBaXJsaWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4N
CkRhdGU6ICAgVGh1IEp1biAxOSAxNDo1NzozMSAyMDA4ICsxMDAwDQoNCiAg
ICBhZ3A6IGJyb3duIHBhcGVyIGJhZyBwYXRjaCAtIHB1dCBiYWNrIHRoZSB0
d28gbGluZXMgaXQgdG9vayBvdXQuDQogICAgDQogICAgbm8gbW9yZSB3aGl0
ZXNwYWNlIGRpZmZzIGZvciBtZS4NCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5
OiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPg0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9jaGFyL2FncC9pbnRlbC1hZ3AuYyBiL2RyaXZlcnMv
Y2hhci9hZ3AvaW50ZWwtYWdwLmMNCmluZGV4IDMwYWEwMWIuLjFhZTY0YmIg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIvYWdwL2ludGVsLWFncC5jDQor
KysgYi9kcml2ZXJzL2NoYXIvYWdwL2ludGVsLWFncC5jDQpAQCAtMTk1OSw2
ICsxOTU5LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBhZ3BfYnJpZGdlX2Ry
aXZlciBpbnRlbF9pOTY1X2RyaXZlciA9IHsNCiAJLnNpemVfdHlwZQkJPSBG
SVhFRF9BUEVSX1NJWkUsDQogCS5udW1fYXBlcnR1cmVfc2l6ZXMJPSA0LA0K
IAkubmVlZHNfc2NyYXRjaF9wYWdlCT0gdHJ1ZSwNCisJLmNvbmZpZ3VyZQkJ
PSBpbnRlbF9pOTE1X2NvbmZpZ3VyZSwNCisJLmZldGNoX3NpemUJCT0gaW50
ZWxfaTl4eF9mZXRjaF9zaXplLA0KIAkuY2xlYW51cAkJPSBpbnRlbF9pOTE1
X2NsZWFudXAsDQogCS50bGJfZmx1c2gJCT0gaW50ZWxfaTgxMF90bGJmbHVz
aCwNCiAJLm1hc2tfbWVtb3J5CQk9IGludGVsX2k5NjVfbWFza19tZW1vcnks
DQo=

--29444707-445143999-1213851702=:14089--
