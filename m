Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXLOBAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXLOBAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXLOA7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:59:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbXLOA7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:59:54 -0500
Message-ID: <476326BE.3080002@redhat.com>
Date: Fri, 14 Dec 2007 19:58:38 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.23.10
References: <20071214194952.GA15765@kroah.com>
In-Reply-To: <20071214194952.GA15765@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
>       Freezer: Fix APM emulation breakage

drivers/char/apm-emulation.c: In function 'apm_ioctl':
drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
make[2]: *** [drivers/char/apm-emulation.o] Error 1
make[1]: *** [drivers/char] Error 2
