Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbZD2URV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbZD2URV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZD2URJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbZD2URG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:17:06 -0400
Date: Wed, 29 Apr 2009 13:16:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore garbage in dell-wmi events
Message-Id: <20090429131613.abed991b.akpm@linux-foundation.org>
In-Reply-To: <49F73F92.9000201@dell.com>
References: <49F73F92.9000201@dell.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 12:40:34 -0500
Mario Limonciello <mario_limonciello@dell.com> wrote:

> In debugging with some future machines that actually contain BIOS level
> support for dell-wmi, I've determined that the upper half of the data
> that comes back from wmi_get_event_data may sometimes contain extra
> information that isn't currently relevant when pulling scan codes out of
> the data.  This causes dell-wmi to improperly respond to these events.
> 
> I'm attaching a patch (Exchange would munge up the line breaks otherwise).

Can you please send along a Signed-off-by: for this patch? 
Documentation/SubmittingPatches explains what it's all about.

Thanks.
