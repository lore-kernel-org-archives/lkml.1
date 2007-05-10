Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbXEJTlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbXEJTlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbXEJTlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:41:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:22301 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbXEJTlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mmLhaNrGTDHVs3t/tx2BO2nJcZZZHIEgzFNsILuJaagW2ygAqezQQJWyNFL2OTdc3KTq4ReH66l4gPdGZveryclUWvtAwx8b9kp4rryG86EEEJW2GgyLvaSosPNd0pg3BULuRe/UWY5YPogDIBO8ZGTXrZFXbGp57Of+8WBI0k4=
Message-ID: <a44ae5cd0705101241m219cb0a0kddab6340d53f505c@mail.gmail.com>
Date: Thu, 10 May 2007 12:41:12 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-mm2 -- Why would HAL from Ubuntu 7.04 not recognize that my machine is a laptop?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.  When I run my test kernel, I notice that gnome-power-manager
doesn't display its applet icon in my gnome panel.  I am wondering if
I am:
1)  using the wrong compile options, which is causing HAL to not be happy
or
2)  something is busted in the kernel
or
3)  there is a HAL version issue (ubuntu's HAL support isn't current)

I ran g-p-m in debug mode and got the following:

$ gnome-power-manager --no-daemon --verbose --debug power
[gpm_debug_init] gpm-debug.c:217 (12:32:57):     Verbose debugging enabled
[main] gpm-main.c:205 (12:32:57):        GNOME Power Manager 2.18.2
[gpm_proxy_connect] gpm-proxy.c:101 (12:32:57):  emitting proxy-status
TRUE: org.freedesktop.Hal
[gpm_proxy_connect] gpm-proxy.c:101 (12:32:57):  emitting proxy-status
TRUE: org.freedesktop.Hal
[gpm_ac_adapter_init] gpm-ac-adapter.c:234 (12:32:57):   No devices of
capability ac_adapter
[gpm_control_init] gpm-control.c:863 (12:32:57):         Using a
supressed policy timeout of 5 seconds
[gpm_refcount_add] gpm-refcount.c:101 (12:32:57):        refcount now: 1
[gpm_refcount_add] gpm-refcount.c:102 (12:32:57):        non zero, so
sending REFCOUNT_ADDED
[gpm_power_refcount_added] gpm-power.c:138 (12:32:57):   Data is now not trusted
[gpm_hash_new_kind_cache] gpm-power.c:1727 (12:32:57):   creating cache
[gpm_hash_new_device_cache] gpm-power.c:1761 (12:32:57):         creating cache
[gpm_warning_init] gpm-warning.c:260 (12:32:57):         Using
per-time notification policy
[gpm_proxy_connect] gpm-proxy.c:101 (12:32:57):  emitting proxy-status
TRUE: org.freedesktop.Hal
[gpm_cpufreq_set_governor] gpm-cpufreq.c:191 (12:32:57):         Doing
SetCPUFreqGovernor (ondemand)
[gpm_cpufreq_set_consider_nice] gpm-cpufreq.c:506 (12:32:57):    Doing
SetCPUFreqConsiderNice (0)
[gpm_cpufreq_set_performance] gpm-cpufreq.c:126 (12:32:57):      Doing
SetCPUFreqPerformance (85)
[gpm_proxy_connect] gpm-proxy.c:101 (12:32:57):  emitting proxy-status
TRUE: org.gnome.ScreenSaver
[gpm_srv_backlight_sync_policy] gpm-srv-backlight.c:151 (12:32:57):
  choosing sensible default
[gpm_hal_is_laptop] gpm-hal.c:1130 (12:32:57):   This machine is not
identified as a laptop.system.formfactor is unknown.
[gpm_srv_backlight_sync_policy] gpm-srv-backlight.c:156 (12:32:57):
  not laptop, so use GPM_SRV_BACKLIGHT_METHOD_STAGGER
[gpm_srv_backlight_sync_policy] gpm-srv-backlight.c:185 (12:32:57):
  SRV_BACKLIGHT parameters 1800 1800 3600, method '1'
[gpm_dpms_set_enabled] gpm-dpms.c:435 (12:32:57):        setting DPMS enabled: 1
[x11_sync_server_dpms_settings] gpm-dpms.c:130 (12:32:57):
Syncing DPMS settings enabled=1 timeouts=0 0 0
[x11_sync_server_dpms_settings] gpm-dpms.c:130 (12:32:57):
Syncing DPMS settings enabled=1 timeouts=0 0 0
[gpm_idle_set_check_cpu] gpm-idle.c:306 (12:32:57):      Setting the
CPU load check to 0
[gpm_manager_init] gpm-manager.c:1564 (12:32:57):        creating new
inhibit instance
[gpm_manager_init] gpm-manager.c:1575 (12:32:57):        creating new
control instance
[gpm_manager_init] gpm-manager.c:1585 (12:32:57):        creating new tray icon
[gpm_manager_init] gpm-manager.c:1594 (12:32:57):        initialising
info infrastructure
[gpm_hal_is_laptop] gpm-hal.c:1130 (12:32:57):   This machine is not
identified as a laptop.system.formfactor is unknown.
[gpm_hal_is_laptop] gpm-hal.c:1130 (12:32:57):   This machine is not
identified as a laptop.system.formfactor is unknown.
[gpm_hal_enable_power_save] gpm-hal.c:1410 (12:32:57):   We are not a
laptop, so not even trying
[gpm_idle_set_system_timeout] gpm-idle.c:357 (12:32:57):
Setting system idle timeout: 0
[get_stock_id] gpm-tray-icon.c:680 (12:32:57):   Trying CRITICAL icon:
primary, ups, mouse, keyboard
[get_stock_id] gpm-tray-icon.c:704 (12:32:57):   Trying CHARGING icon:
primary, ups
[get_stock_id] gpm-tray-icon.c:716 (12:32:57):   no devices
(dis)charging, so no icon will be displayed.
[gpm_tray_icon_sync] gpm-tray-icon.c:763 (12:32:57):     Going to use
stock id: (null)
[gpm_tray_icon_sync] gpm-tray-icon.c:783 (12:32:57):     no icon will
be displayed
[gpm_refcount_auto_decrement] gpm-refcount.c:75 (12:32:57):      zero,
so sending REFCOUNT_ZERO
[gpm_power_refcount_zero] gpm-power.c:123 (12:32:57):    Data is now trusted
[get_stock_id] gpm-tray-icon.c:680 (12:32:57):   Trying CRITICAL icon:
primary, ups, mouse, keyboard
[get_stock_id] gpm-tray-icon.c:704 (12:32:57):   Trying CHARGING icon:
primary, ups
[get_stock_id] gpm-tray-icon.c:716 (12:32:57):   no devices
(dis)charging, so no icon will be displayed.
[gpm_tray_icon_sync] gpm-tray-icon.c:763 (12:32:57):     Going to use
stock id: (null)
[gpm_tray_icon_sync] gpm-tray-icon.c:783 (12:32:57):     no icon will
be displayed
[battery_status_changed_primary] gpm-manager.c:957 (12:32:57):
Laptop battery is not discharging
