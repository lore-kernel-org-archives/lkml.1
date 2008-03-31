Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYCaQeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYCaQeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYCaQd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:33:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbYCaQdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:33:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Didier Raboud <didier@raboud.com>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Mon, 31 Mar 2008 18:33:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com>
In-Reply-To: <200803311823.36693.didier@raboud.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803311833.19730.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 31 of March 2008, Didier Raboud wrote:
> Hi, 

Hi,
 
> I'm using the latest Debian 2.6.25-rc7 kernel [0] and I have big troubles with 
> hibernation. With this version, the hibernation (suspend on disk) is 
> sometimes not resuming correctly. The only thing I get is a blinking cursor 
> at the top-left of the screen. The problem is that it is not easily 
> reproducible : sometimes it works, sometimes not.
> 
> AFAIK, 2.6.24 is not affected, but 2.6.25-rc6 and -rc7 (at least) are.
> 
> I'm using a Dell Latitude D630. (lspci attached).
> 
> Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successful 
> hibernate/resume cycles.

Could you please check if the problem is still present if you boot with
acpi_new_pts_ordering kernel command line argument?

Thanks,
Rafael
