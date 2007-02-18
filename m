Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXBRXWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXBRXWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXBRXWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:22:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36773 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbXBRXWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:22:52 -0500
Date: Mon, 19 Feb 2007 00:22:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070218232249.GA11730@one.firstfloor.org>
References: <45D5EA88.7090300@redhat.com> <p73odntg9ga.fsf@bingen.suse.de> <45D606A0.5020606@redhat.com> <20070218183219.557856dc.khali@linux-fr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218183219.557856dc.khali@linux-fr.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You could blacklist the ACPI "thermal" module instead. If you're
> interested in monitoring your CPU temperature, k8temp is IMHO more
> convenient to use than ACPI, as it interfaces properly with libsensors
> and all hardware monitoring user interfaces.

That would be somewhat dangerous because ACPI thermal does more than
just displaying the temperature. Especially laptops often need it.

-Andi
