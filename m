Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZDQDi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZDQDi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZDQDis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 23:38:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:16692 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZDQDir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 23:38:47 -0400
Message-ID: <49E7F9B7.2090804@gawab.com>
Date: Thu, 16 Apr 2009 20:38:31 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #13067] iwl3945: wlan0: beacon loss from AP - sending probe
 request
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.giB.rw85JB@chimera>
In-Reply-To: <nY3-4PrO6XH.A.giB.rw85JB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13067
> Subject		: iwl3945: wlan0: beacon loss from AP - sending probe request
> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2009-04-05 9:11 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=123892272218266&w=4
>
>
>   
I'm getting this on .30rc2, so I confirm that it's still an issue (I'm 
not the original submitter).
It's really annoying because it's filling my logs like crazy. Below is 
15mins of logs, and it just repeats like this.

dhclient: DHCPREQUEST of 192.168.1.5 on wlan0 to 192.168.1.254 port 67
dhclient: DHCPACK of 192.168.1.5 from 192.168.1.254
dhclient: bound to 192.168.1.5 -- renewal in 823 seconds.
NetworkManager: <debug> [1239937333.003788] periodic_update(): Roamed 
from BSSID 00:1C:DF:67:1F:AC (madru) to (none) ((none))
kernel: wlan0: beacon loss from AP 00:1c:df:67:1f:ac - sending probe request
NetworkManager: <debug> [1239937339.001004] periodic_update(): Roamed 
from BSSID (none) ((none)) to 00:1C:DF:67:1F:AC (madru)
NetworkManager: <debug> [1239937453.002911] periodic_update(): Roamed 
from BSSID 00:1C:DF:67:1F:AC (madru) to (none) ((none))
kernel: wlan0: beacon loss from AP 00:1c:df:67:1f:ac - sending probe request
NetworkManager: <debug> [1239937459.000974] periodic_update(): Roamed 
from BSSID (none) ((none)) to 00:1C:DF:67:1F:AC (madru)
NetworkManager: <debug> [1239937573.002956] periodic_update(): Roamed 
from BSSID 00:1C:DF:67:1F:AC (madru) to (none) ((none))
kernel: wlan0: beacon loss from AP 00:1c:df:67:1f:ac - sending probe request
NetworkManager: <debug> [1239937579.000971] periodic_update(): Roamed 
from BSSID (none) ((none)) to 00:1C:DF:67:1F:AC (madru)
NetworkManager: <debug> [1239937693.003787] periodic_update(): Roamed 
from BSSID 00:1C:DF:67:1F:AC (madru) to (none) ((none))
kernel: wlan0: beacon loss from AP 00:1c:df:67:1f:ac - sending probe request
NetworkManager: <debug> [1239937699.000981] periodic_update(): Roamed 
from BSSID (none) ((none)) to 00:1C:DF:67:1F:AC (madru)
NetworkManager: <debug> [1239937813.002710] periodic_update(): Roamed 
from BSSID 00:1C:DF:67:1F:AC (madru) to (none) ((none))
kernel: wlan0: beacon loss from AP 00:1c:df:67:1f:ac - sending probe request
NetworkManager: <debug> [1239937819.000753] periodic_update(): Roamed 
from BSSID (none) ((none)) to 00:1C:DF:67:1F:AC (madru)
NetworkManager: <debug> [1239937933.003806] periodic_update(): Roamed 
from BSSID 00:1C:DF:67:1F:AC (madru) to (none) ((none))
kernel: wlan0: beacon loss from AP 00:1c:df:67:1f:ac - sending probe request
NetworkManager: <debug> [1239937939.000724] periodic_update(): Roamed 
from BSSID (none) ((none)) to 00:1C:DF:67:1F:AC (madru)
NetworkManager: <debug> [1239938053.002711] periodic_update(): Roamed 
from BSSID 00:1C:DF:67:1F:AC (madru) to (none) ((none))
kernel: wlan0: beacon loss from AP 00:1c:df:67:1f:ac - sending probe request
NetworkManager: <debug> [1239938059.001749] periodic_update(): Roamed 
from BSSID (none) ((none)) to 00:1C:DF:67:1F:AC (madru)
dhclient: DHCPREQUEST of 192.168.1.5 on wlan0 to 192.168.1.254 port 67
dhclient: DHCPACK of 192.168.1.5 from 192.168.1.254
dhclient: bound to 192.168.1.5 -- renewal in 803 seconds.

Justin Madru
