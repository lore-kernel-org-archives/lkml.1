Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYHTDCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYHTDCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 23:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYHTDCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 23:02:40 -0400
Received: from usul.saidi.cx ([204.11.33.34]:59756 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752240AbYHTDCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 23:02:39 -0400
Message-ID: <48AB8941.4080209@overt.org>
Date: Tue, 19 Aug 2008 20:02:25 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v5)
References: <48A728B0.8030206@overt.org> <20080820012936.GE29336@khazad-dum.debian.net>
In-Reply-To: <20080820012936.GE29336@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
>> +		toshiba_acpi.rfk_dev->state = RFKILL_STATE_OFF;
> 
> Where did that RFKILL_STATE_OFF came from ? :-)  Just get rid of it, you
> override it four statements later anyway...

Left over from the first iteration. Now removed and diff updated.

> 
> Other than that, the rfkill bits look fine to me.
> 

Thanks. Anyone else care to voice an opinion? Should this go in through
wireless-testing then?

--phil
