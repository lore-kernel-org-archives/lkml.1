Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbYHBEJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbYHBEJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 00:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYHBEJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 00:09:29 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:44923 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751057AbYHBEJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 00:09:28 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2008 00:09:28 EDT
Message-ID: <4893DC52.9060203@gawab.com>
Date: Fri, 01 Aug 2008 21:02:26 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [2.6.27-rc1] Can't connect to encrypted network
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I use the 2.6.27-rc1 kernel I can't connect to an encrypted 
network; the connection times out. Connecting to unencrypted works fine.
If I use my distro's kernel (2.6.24) or my build 2.6.26 kernel it is 
able to connect. I'm using Ubuntu 8.4 and an intel 3945 card.
Am I doing something wrong? or is this a regression? I get the following 
in my syslog:

NetworkManager: <debug> [1217605131.709159] 
nm_device_802_11_wireless_get_activation_ap(): Forcing AP '6DTY0'
NetworkManager: <info>  User Switch: 
/org/freedesktop/NetworkManager/Devices/wlan0 / 6DTY0
NetworkManager: <info>  Deactivating device wlan0.
dhclient: There is already a pid file /var/run/dhclient.wlan0.pid with 
pid 4333
dhclient: killed old client process, removed PID file
dhclient: wmaster0: unknown hardware address type 801
dhclient: wmaster0: unknown hardware address type 801
dhclient: DHCPRELEASE on wlan0 to 192.168.1.254 port 67
avahi-daemon[3220]: Withdrawing address record for 192.168.1.5 on wlan0.
avahi-daemon[3220]: Leaving mDNS multicast group on interface wlan0.IPv4 
with address 192.168.1.5.
avahi-daemon[3220]: Interface wlan0.IPv4 no longer relevant for mDNS.
NetworkManager: <info>  Device wlan0 activation scheduled...
NetworkManager: <info>  Activation (wlan0) started...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device Prepare) 
scheduled...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device Prepare) 
started...
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device 
Configure) scheduled...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device Prepare) 
complete.
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device 
Configure) starting...
NetworkManager: <info>  Activation (wlan0/wireless): access point 
'6DTY0' is encrypted, but NO valid key exists.  New key needed.
NetworkManager: <info>  Activation (wlan0) New wireless user key 
requested for network '6DTY0'.
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device 
Configure) complete.
NetworkManager: <info>  Activation (wlan0) New wireless user key for 
network '6DTY0' received.
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device Prepare) 
scheduled...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device Prepare) 
started...
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device 
Configure) scheduled...
NetworkManager: <info>  Activation (wlan0) Stage 1 of 5 (Device Prepare) 
complete.
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device 
Configure) starting...
NetworkManager: <info>  Activation (wlan0/wireless): access point 
'6DTY0' is encrypted, and a key exists.  No new key needed.
NetworkManager: <info>  retry to connect to global supplicant socket 
(try=1)
NetworkManager: <info>  SUP: sending command 'INTERFACE_ADD 
wlan0^I^Iwext^I/var/run/wpa_supplicant0^I'
NetworkManager: <info>  SUP: response was 'OK'
NetworkManager: <info>  SUP: sending command 'AP_SCAN 1'
NetworkManager: <info>  SUP: response was 'OK'
NetworkManager: <info>  SUP: sending command 'ADD_NETWORK'
NetworkManager: <info>  SUP: response was '0'
NetworkManager: <info>  SUP: sending command 'SET_NETWORK 0 ssid 
3644545930'
NetworkManager: <info>  SUP: response was 'OK'
NetworkManager: <info>  SUP: sending command 'SET_NETWORK 0 key_mgmt NONE'
NetworkManager: <info>  SUP: response was 'OK'
NetworkManager: <info>  SUP: sending command 'SET_NETWORK 0 wep_key0 <key>'
NetworkManager: <info>  SUP: response was 'OK'
NetworkManager: <info>  SUP: sending command 'SET_NETWORK 0 
wep_tx_keyidx 0'
NetworkManager: <info>  SUP: response was 'OK'
NetworkManager: <info>  SUP: sending command 'ENABLE_NETWORK 0'
NetworkManager: <info>  SUP: response was 'OK'
NetworkManager: <info>  Activation (wlan0) Stage 2 of 5 (Device 
Configure) complete.
NetworkManager: <info>  Supplicant state changed: 0
last message repeated 27 times
NetworkManager: <info>  Supplicant state changed: 1
NetworkManager: <info>  Activation (wlan0/wireless) Stage 2 of 5 (Device 
Configure) successful.  Connected to access point '6DTY0'.
NetworkManager: <info>  Activation (wlan0) Stage 3 of 5 (IP Configure 
Start) scheduled.
NetworkManager: <info>  Activation (wlan0) Stage 3 of 5 (IP Configure 
Start) started...
NetworkManager: <info>  Activation (wlan0) Beginning DHCP transaction.
NetworkManager: <info>  DHCP daemon state is now 12 (successfully 
started) for interface wlan0
NetworkManager: <info>  Activation (wlan0) Stage 3 of 5 (IP Configure 
Start) complete.
dhclient: There is already a pid file /var/run/dhclient.wlan0.pid with 
pid 134519072
dhclient: wmaster0: unknown hardware address type 801
dhclient: wmaster0: unknown hardware address type 801
NetworkManager: <info>  DHCP daemon state is now 1 (starting) for 
interface wlan0
NetworkManager: <info>  Old device 'wlan0' activating, won't change.
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 6
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 10
dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 15
ntpd[4566]: sendto(217.160.254.116) (fd=18): Invalid argument
ntpd[4566]: sendto(69.65.110.186) (fd=18): Invalid argument
ntpd[4566]: sendto(204.152.186.173) (fd=18): Invalid argument
ntpd[4566]: sendto(69.36.240.252) (fd=18): Invalid argument
dhclient: No DHCPOFFERS received.
dhclient: Trying recorded lease 192.168.1.17
avahi-daemon[3220]: Joining mDNS multicast group on interface wlan0.IPv4 
with address 192.168.1.17.
avahi-daemon[3220]: New relevant interface wlan0.IPv4 for mDNS.
avahi-daemon[3220]: Registering new address record for 192.168.1.17 on 
wlan0.IPv4.
avahi-daemon[3220]: Withdrawing address record for 192.168.1.17 on wlan0.
avahi-daemon[3220]: Leaving mDNS multicast group on interface wlan0.IPv4 
with address 192.168.1.17.
avahi-daemon[3220]: Interface wlan0.IPv4 no longer relevant for mDNS.
avahi-autoipd(wlan0)[5220]: Found user 'avahi-autoipd' (UID 104) and 
group 'avahi-autoipd' (GID 112).
avahi-autoipd(wlan0)[5220]: Successfully called chroot().
avahi-autoipd(wlan0)[5220]: Successfully dropped root privileges.
avahi-autoipd(wlan0)[5220]: Starting with address 169.254.8.72
avahi-autoipd(wlan0)[5220]: Callout BIND, address 169.254.8.72 on 
interface wlan0
avahi-daemon[3220]: Joining mDNS multicast group on interface wlan0.IPv4 
with address 169.254.8.72.
avahi-daemon[3220]: New relevant interface wlan0.IPv4 for mDNS.
avahi-daemon[3220]: Registering new address record for 169.254.8.72 on 
wlan0.IPv4.
ntpd[4566]: Listening on interface #3 wlan0:avahi, 169.254.8.72#123 Enabled
ntpd[4566]: Deleting interface #2 wlan0, 192.168.1.5#123, interface 
stats: received=36, sent=36, dropped=4, active_time=601 secs
avahi-autoipd(wlan0)[5220]: Successfully claimed IP address 169.254.8.72
NetworkManager: <info>  DHCP daemon state is now 8 (timeout) for 
interface wlan0
NetworkManager: <info>  Activation (wlan0) Stage 4 of 5 (IP Configure 
Timeout) started...
NetworkManager: <debug> [1217605189.015977] 
real_act_stage4_ip_config_timeout(): Activation (wlan0/wireless): could 
not get IP configuration info for '6DTY0', asking for new key.
NetworkManager: <info>  Activation (wlan0) Stage 4 of 5 (IP Configure 
Timeout) scheduled...
dhclient: Trying recorded lease 192.168.1.1
avahi-autoipd(wlan0)[5220]: A routable address has been configured.
avahi-daemon[3220]: Leaving mDNS multicast group on interface wlan0.IPv4 
with address 169.254.8.72.
avahi-autoipd(wlan0)[5220]: Callout UNBIND, address 169.254.8.72 on 
interface wlan0
avahi-daemon[3220]: Joining mDNS multicast group on interface wlan0.IPv4 
with address 192.168.1.1.
avahi-daemon[3220]: Registering new address record for 192.168.1.1 on 
wlan0.IPv4.
avahi-daemon[3220]: Withdrawing address record for 169.254.8.72 on wlan0.
NetworkManager: <info>  Activation (wlan0) New wireless user key 
requested for network '6DTY0'.
NetworkManager: <info>  Activation (wlan0) Stage 4 of 5 (IP Configure 
Timeout) complete.
avahi-autoipd(wlan0)[5220]: No longer a routable address configured, 
restarting probe process.
avahi-daemon[3220]: Withdrawing address record for 192.168.1.1 on wlan0.
avahi-daemon[3220]: Leaving mDNS multicast group on interface wlan0.IPv4 
with address 192.168.1.1.
avahi-daemon[3220]: Interface wlan0.IPv4 no longer relevant for mDNS.
dhclient: Trying recorded lease 192.168.1.65
NetworkManager: <info>  DHCP daemon state is now 8 (timeout) for 
interface wlan0
avahi-autoipd(wlan0)[5220]: A routable address has been configured.
avahi-daemon[3220]: Joining mDNS multicast group on interface wlan0.IPv4 
with address 192.168.1.65.
avahi-daemon[3220]: New relevant interface wlan0.IPv4 for mDNS.
avahi-daemon[3220]: Registering new address record for 192.168.1.65 on 
wlan0.IPv4.
NetworkManager: <info>  Activation (wlan0) New wireless user key request 
for network '6DTY0' was canceled.
NetworkManager: <info>  Activation (wlan0) failure scheduled...
NetworkManager: <info>  Activation (wlan0) failed for access point (6DTY0)
NetworkManager: <info>  Activation (wlan0) failed.
NetworkManager: <info>  Deactivating device wlan0.
dhclient: There is already a pid file /var/run/dhclient.wlan0.pid with 
pid 5169
dhclient: killed old client process, removed PID file
dhclient: wmaster0: unknown hardware address type 801
dhclient: wmaster0: unknown hardware address type 801
avahi-autoipd(wlan0)[5220]: No longer a routable address configured, 
restarting probe process.
avahi-daemon[3220]: Withdrawing address record for 192.168.1.65 on wlan0.
avahi-daemon[3220]: Leaving mDNS multicast group on interface wlan0.IPv4 
with address 192.168.1.65.
avahi-daemon[3220]: Interface wlan0.IPv4 no longer relevant for mDNS.
dhclient: DHCPRELEASE on wlan0 to 192.168.1.254 port 67
dhclient: send_packet: Network is unreachable
dhclient: send_packet: please consult README file regarding broadcast 
address.
avahi-autoipd(wlan0)[5220]: Got SIGTERM, quitting.

Justin Madru
