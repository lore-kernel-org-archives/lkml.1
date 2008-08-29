Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbYH2VZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbYH2VZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYH2VZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:25:37 -0400
Received: from usul.saidi.cx ([204.11.33.34]:60875 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753498AbYH2VZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:25:37 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] =?UTF-8?Q?toshiba=5Facpi=3A=20Add=20support=20for=20bluet?=
 =?UTF-8?Q?ooth=20togglingthrough=20rfkill=20=28v=37=29?=
MIME-Version: 1.0
Date: Fri, 29 Aug 2008 17:26:05 -0400
From: Philip Langdale <philipl@overt.org>
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
       toshiba_acpi@memebeam.org, ivdoorn@gmail.com,
       linux-wireless@vger.kernel.org, hmh@hmh.eng.br
In-Reply-To: <20080829141216.f0d69ae4.akpm@linux-foundation.org>
References: <20080829141216.f0d69ae4.akpm@linux-foundation.org>
Message-ID: <f86c32a17907fdacd870e853761f0382@localhost>
User-Agent: RoundCube Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 Aug 2008 14:12:16 -0700, Andrew Morton
<akpm@linux-foundation.org> wrote:
> 
> ERROR: "rfkill_force_state" [drivers/acpi/toshiba_acpi.ko] undefined!
> ERROR: "rfkill_free" [drivers/acpi/toshiba_acpi.ko] undefined!
> ERROR: "rfkill_register" [drivers/acpi/toshiba_acpi.ko] undefined!
> ERROR: "rfkill_allocate" [drivers/acpi/toshiba_acpi.ko] undefined!
> ERROR: "rfkill_unregister" [drivers/acpi/toshiba_acpi.ko] undefined!
> 
> I'll stick a `select RFKILL' in there, but it'll probably blow up
> in other ways.  select usually does.

Sorry, thanks for catching that. thinkpad_acpi also just does 'select
RFKILL',
so hopefully it'll be ok.

--phil

