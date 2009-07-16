Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbZGPOiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbZGPOiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbZGPOiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:38:09 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:52367 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbZGPOiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:38:08 -0400
Message-ID: <4A5F3ADE.2040109@s5r6.in-berlin.de>
Date: Thu, 16 Jul 2009 16:36:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <4A5F3975.70503@s5r6.in-berlin.de>
In-Reply-To: <4A5F3975.70503@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> The comment should specify what the actual effects of the flag are.
[...]
> (Is used by power management infrastructure to decide over runtime PM
> policy?  I.e. don't enter power states which would prevent the port from
> detecting/ reporting hotplug events?)

Perhaps the flag should be called differently (keep_ports_powered or
whatever) --- unless you have additional future uses of the flag in mind
which justify the more generic name.
-- 
Stefan Richter
-=====-==--= -=== =----
http://arcgraph.de/sr/
