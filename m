Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYDCPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYDCPk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYDCPkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:40:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24083 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbYDCPkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:40:20 -0400
Date: Thu, 3 Apr 2008 08:39:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tom Horsley <tom.horsley@ccur.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: module parameters versus kernel command line
Message-Id: <20080403083953.42ea3f1d.randy.dunlap@oracle.com>
In-Reply-To: <20080403090053.56f243df@tomh>
References: <20080403090053.56f243df@tomh>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 09:00:53 -0400 Tom Horsley wrote:

> Just curious: Is there any reason even dynamically loaded
> modules shouldn't be able to find module parameters on
> the kernel command line? I haven't actually investigated
> the code involved (since I have no idea where it is :-),
> but it sure seems like it would be convenient to have
> a single place to put module parameters where they
> would always be found regardless of the module's static
> or dynamic build mode (especially when multi-booting
> different kernels built different ways).
> --

Does this answer your question?  from Documentation/kernel-parameters.txt:

Module parameters for loadable modules are specified only as the
parameter name with optional '=' and value as appropriate, such as:

	modprobe usbcore blinkenlights=1

Module parameters for modules that are built into the kernel image
are specified on the kernel command line with the module name plus
'.' plus parameter name, with '=' and value if appropriate, such as:

	usbcore.blinkenlights=1

---
~Randy
