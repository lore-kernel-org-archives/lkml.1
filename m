Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbZINK76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbZINK76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZINK74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:59:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51628 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINK74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:59:56 -0400
Date: Mon, 14 Sep 2009 11:59:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentincj@iksaif.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] hp-wmi: fix rfkill memory leak on unload
Message-ID: <20090914105950.GB6170@srcf.ucam.org>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net> <1252925033-29696-2-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252925033-29696-2-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:43:51PM +0200, Corentin Chary wrote:
> rfkill_unregister() should always be followed by rfkill_destroy()
> In this case, rfkill_destroy was called two times on wifi_rfkill and
> never on bluetooth_rfkill.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
