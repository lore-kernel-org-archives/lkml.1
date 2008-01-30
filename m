Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbYA3OHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbYA3OHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760634AbYA3OHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:07:16 -0500
Received: from mailout03.sul.t-online.de ([194.25.134.81]:56208 "EHLO
	mailout03.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760650AbYA3OHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:07:13 -0500
X-Greylist: delayed 3760 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 09:07:13 EST
Message-ID: <47A075CD.6050800@t-online.de>
Date: Wed, 30 Jan 2008 14:04:13 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@analog.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [NOMMU]: Dont use kobjsize on the area belonging
 to a VMA
References: <1201688708-2152-1-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1201688708-2152-1-git-send-email-bryan.wu@analog.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: SyYSsmZ-YhCYaxmkyltsAyuR0dS44kfXqRS+Nr5TREwohU2wRohAHS1+3MVLZWrw8v
X-TOI-MSGID: 84f1aba1-0a6a-4605-bb45-e8c91c0c8cc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Bernd Schmidt <bernd.schmidt@analog.com>
> 
> Dont use kobjsize on the area belonging to a VMA, as it's allocated with
> get_free_pages.

As far as I remember, that's the case only in our tree with the patches
in nommu.c.  So this patch probably shouldn't go upstream yet.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
