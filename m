Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZEZQgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZEZQgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZEZQgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:36:37 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33798 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZEZQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:36:36 -0400
Message-ID: <4A1C1A79.2020500@s5r6.in-berlin.de>
Date: Tue, 26 May 2009 18:36:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@users.sf.net>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Question on the removable flag of USB devices
References: <20090525164553.GA5572@ime.usp.br> <20090525184831.GT28077@one-eyed-alien.net>
In-Reply-To: <20090525184831.GT28077@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm wrote:
> On Mon, May 25, 2009 at 01:45:54PM -0300, Rogério Brito wrote:
>> The question is: how are devices determined to be removable or not?
>> Sorry if this question is too naive.
> 
> It's a bit that the device reports.  The usb-storage driver passes this bit
> to the SCSI layer.

Wasn't this bit actually about removable _media_ rather than
hotpluggable transports?  (I.e. hardware where you can pull the medium
out of the drive mechanism.)  So in this sense, an USB attached HDD
should actually not present itself as "removable" unless it's a SyQuest
or Zip or something like that.

Furthermore, if that's what the discussed bit stands for, than it is
rather arbitrary to base a policy on it whether a volume may be mounted
by non-root users or not.

Rogério, perhaps static fstab entries based on /dev/disk/by-id/... can help.
-- 
Stefan Richter
-=====-==--= -=-= ==-=-
http://arcgraph.de/sr/
