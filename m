Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYLXGjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYLXGjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 01:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYLXGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 01:38:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:28145 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYLXGi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 01:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:cc
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YJLdvH+vkKanoMal4U/NVMjss5geGjFhq2uf6rZZu1BT4NtPbeVIduIetNY3ck9nV8
         bxXbQp15b4CE3TqdY5jqSUvKpYWqnc9hwWLYSQs/Kj1e5JSLFZV0WHiKjmYLpZHQ13oV
         g7cng5Pqew/lTrXoX3qQZ6o7Y0lCKr8NgGEfU=
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Question about not saving power
Date: Wed, 24 Dec 2008 11:38:01 +0500
User-Agent: KMail/1.10.92 (Linux/2.6.27-ARCH; KDE/4.1.85; i686; ; )
References: <200812241050.24804.patrakov@gmail.com> <1230099417.21770.4.camel@marge.simson.net>
In-Reply-To: <1230099417.21770.4.camel@marge.simson.net>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812241138.01961.patrakov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 December 2008 11:16:57 you wrote:
> On Wed, 2008-12-24 at 10:50 +0500, Alexander E. Patrakov wrote:
> > My question is: what are my options (like kernel parameters) to disable
> > power- saving features, other than running such CPU-eating process
> > continuously?
>
> You can set your performance governor to "performance".  If you're using
> KDE, in the lower right corner of your display is an icon for that.  I
> don't know what Gnome looks like.  Anyway, you can set it manually as
> well...
>
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors

I don't have the cpufreq driver loaded normally, so these files don't exist. 
And this is my home desktop, not the corporate laptop. After modprobing 
"cpufreq-acpi", the file does appear and contains "performance". The tone 
doesn't disappear, though.

-- 
Alexander E. Patrakov
