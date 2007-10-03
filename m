Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbXJCOvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbXJCOvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXJCOvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:51:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35297 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXJCOvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:51:46 -0400
Date: Wed, 3 Oct 2007 17:51:45 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Frans Pop <elendil@planet.nl>
cc: LKML <linux-kernel@vger.kernel.org>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: top displaying 9999% CPU usage
In-Reply-To: <Pine.LNX.4.64.0710031731030.27745@kivilampi-30.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0710031746260.27745@kivilampi-30.cs.helsinki.fi>
References: <200710031433.34504.elendil@planet.nl> <4703932C.6060900@ums.usu.ru>
 <200710031604.07365.elendil@planet.nl> <Pine.LNX.4.64.0710031731030.27745@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; boundary="-696243703-355394179-1191422961=:27745"
Content-ID: <Pine.LNX.4.64.0710031751280.27745@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-355394179-1191422961=:27745
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0710031751281.27745@kivilampi-30.cs.helsinki.fi>

On Wed, 3 Oct 2007, Ilpo Järvinen wrote:

> On Wed, 3 Oct 2007, Frans Pop wrote:
> 
> > The only change is in 2 consecutive columns: "2911 502" -> "2912 500".
> > Is processor usage calculated from those? Can someone explain how?
> 
> The latter seems to be utime ...decreasing. No wonder if arithmetics will 
> give strange results (probably top is using unsigned delta?)...

Hmm, minor miscounting from my side, stime seems more appropriate...

-- 
 i.
---696243703-355394179-1191422961=:27745--
