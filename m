Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZLKQ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZLKQ2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZLKQ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:28:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:52208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZLKQ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hXljfjAdQf4bOrlzyyFxub84GipWtXGEPxQBv3sfkv3gzetAh87KgOI/ezG3E7h6UL
         jvBVkvrFtEco0HKnc+dzlPf59ZdxQhKEs00AuAaeCJLCPYy14Z/AuVAQTiDj26iljbWv
         V5uBtrhF6GHuIa2RRWZeFxhMpT+MwqJO+1MP0=
MIME-Version: 1.0
In-Reply-To: <1260546750-6206-1-git-send-email-mjg@redhat.com>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>
Date: Fri, 11 Dec 2009 17:28:37 +0100
Message-ID: <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal 
	subsystem
From: Luca Tettamanti <kronos.it@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 4:52 PM, Matthew Garrett <mjg@redhat.com> wrote:
> Recent Intel chipsets have support for a PCI device providing access
> to on-board thermal monitoring. Previous versions have merely used this
> to allow the BIOS to set trip points, but Ibex Peak documents a set of
> registers to read values. This driver implements an hwmon interface to
> read them.

Does it plays nice with other drivers?
More specifically: is it possible to load the native driver and this
one (which I presume pokes at the same chip) at the same time?

Luca
