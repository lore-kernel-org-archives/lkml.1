Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZG3WFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZG3WFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZG3WFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:05:21 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:50324 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZG3WFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fgIloiIaHWzmb+A1dm24mzYY73pB70BOWQ5OvKIWhj6Tq9UU79w7+DGUF3lRDQkGTH
         VhbfWI0IEmE15B2DpclL1IECu4L/5YaPt8Logc0j5WEnz7cRCiu2Oe66k71uW7ypdmW5
         EPcm+Vw3QCxg39/FjaTc6FkUK0oaXnbW+lrMc=
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Manuel Lauss <manuel.lauss@gmail.com>,
       Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1248908025.3998.15.camel@green>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
	 <1248648663.3718.7.camel@green> <1248824367.4112.31.camel@green>
	 <200907292249.47761.rjw@sisk.pl>
	 <20090729213756.D23EF526EC9@mailhub.coreip.homeip.net>
	 <1248908025.3998.15.camel@green>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 18:05:09 -0400
Message-Id: <1248991509.4901.9.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 18:53 -0400, Arnaud Faucher wrote :
> As of today, acer_platform_freeze() does not stop/reset any device, so,
> I agree with Rafael that for acer-wmi, .thaw() can be skipped. I had
> also tested this configuration and it was working like the non-patched
> code.
> 
> Carlos, do you think that any acer-specific hardware could be switched
> off or reset inside acer_platform_freeze() ? If this was the case, we
> would have to wire .thaw()...
> 

Should I send a new patch with only .freeze() and .restore() wired ?

---
Hope to see Cox and Torvalds reconcile...

