Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0CDWR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:17:26 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:39871 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0CDWRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:17:23 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Hank Janssen <hjanssen@microsoft.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>, Hashir Abdi <habdi@microsoft.com>,
       Greg KH <greg@kroah.com>, "joe@perches.com" <joe@perches.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 1/1] Stage: hv: Corrected all header comments to follow
 kernel-doc format-CORRECTED
Thread-Topic: [PATCH 1/1] Stage: hv: Corrected all header comments to follow
 kernel-doc format-CORRECTED
Thread-Index: AQHKu+eSf/plNs4XDE6cnPmNgyPceg==
Date: Thu, 4 Mar 2010 22:11:00 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56217DC1B2C@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hank Janssen <hjanssen@microsoft.com>

Removed kerneldoc /** from functions that should not have them.
Added proper kerneldoc headers to functions that should have them.

This includes fixes as pointed out by Randy Dunlap and Joe Perches.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>


---
 drivers/staging/hv/Channel.c     |   49 ++++++++++++++-----------
 drivers/staging/hv/ChannelMgmt.c |   33 +++++++++--------
 drivers/staging/hv/Connection.c  |   14 ++++----
 drivers/staging/hv/Hv.c          |   18 +++++-----
 drivers/staging/hv/NetVsc.c      |    8 ++--
 drivers/staging/hv/StorVsc.c     |   10 +++---
 drivers/staging/hv/TODO          |    1 -
 drivers/staging/hv/Vmbus.c       |   26 +++++++-------
 drivers/staging/hv/VmbusApi.h    |   18 +++++++++
 drivers/staging/hv/blkvsc_drv.c  |    6 ++--
 drivers/staging/hv/netvsc_drv.c  |    7 ++--
 drivers/staging/hv/osd.c         |   70 +++++++++++++++++++++++++++++++++++
 drivers/staging/hv/storvsc_drv.c |   14 ++++----
 drivers/staging/hv/vmbus_drv.c   |   74 +++++++++++++++++++++++++------------
 14 files changed, 234 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index d46eb14..1fc2710 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -64,8 +64,9 @@ static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)
 }
 #endif

-/**
- * VmbusChannelSetEvent - Trigger an event notification on the specified channel.
+/*
+ * VmbusChannelSetEvent - Trigger an event notification on the specified
+ * channel.
  */
 static void VmbusChannelSetEvent(struct vmbus_channel *Channel)
 {
@@ -119,7 +120,7 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 }

 #endif
-/**
+/*
  * VmbusChannelGetDebugInfo -Retrieve various channel debug info
  */
 void VmbusChannelGetDebugInfo(struct vmbus_channel *Channel,
@@ -164,7 +165,7 @@ void VmbusChannelGetDebugInfo(struct vmbus_channel *Channel,
        RingBufferGetDebugInfo(&Channel->Outbound, &DebugInfo->Outbound);
 }

-/**
+/*
  * VmbusChannelOpen - Open the specified channel.
  */
 int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
@@ -282,8 +283,9 @@ Cleanup:
        return 0;
 }

-/**
- * DumpGpadlBody - Dump the gpadl body message to the console for debugging purposes.
+/*
+ * DumpGpadlBody - Dump the gpadl body message to the console for
+ * debugging purposes.
  */
 static void DumpGpadlBody(struct vmbus_channel_gpadl_body *Gpadl, u32 Len)
 {
@@ -299,8 +301,9 @@ static void DumpGpadlBody(struct vmbus_channel_gpadl_body *Gpadl, u32 Len)
                           i, Gpadl->Pfn[i]);
 }

-/**
- * DumpGpadlHeader - Dump the gpadl header message to the console for debugging purposes.
+/*
+ * DumpGpadlHeader - Dump the gpadl header message to the console for
+ * debugging purposes.
  */
 static void DumpGpadlHeader(struct vmbus_channel_gpadl_header *Gpadl)
 {
@@ -324,7 +327,7 @@ static void DumpGpadlHeader(struct vmbus_channel_gpadl_header *Gpadl)
        }
 }

-/**
+/*
  * VmbusChannelCreateGpadlHeader - Creates a gpadl for the specified buffer
  */
 static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
@@ -440,7 +443,7 @@ static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
        return 0;
 }

-/**
+/*
  * VmbusChannelEstablishGpadl - Estabish a GPADL for the specified buffer
  *
  * @Channel: a channel
@@ -544,7 +547,7 @@ Cleanup:
        return ret;
 }

-/**
+/*
  * VmbusChannelTeardownGpadl -Teardown the specified GPADL handle
  */
 int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
@@ -597,7 +600,7 @@ int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
        return ret;
 }

-/**
+/*
  * VmbusChannelClose - Close the specified channel
  */
 void VmbusChannelClose(struct vmbus_channel *Channel)
@@ -662,7 +665,7 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelSendPacket - Send the specified buffer on the given channel
  */
 int VmbusChannelSendPacket(struct vmbus_channel *Channel, const void *Buffer,
@@ -708,8 +711,9 @@ int VmbusChannelSendPacket(struct vmbus_channel *Channel, const void *Buffer,
        return ret;
 }

-/**
- * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer packets using a GPADL Direct packet type.
+/*
+ * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer
+ * packets using a GPADL Direct packet type.
  */
 int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
                                     struct hv_page_buffer PageBuffers[],
@@ -773,8 +777,9 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
        return ret;
 }

-/**
- * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer packet using a GPADL Direct packet type.
+/*
+ * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer packet
+ * using a GPADL Direct packet type.
  */
 int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
                                struct hv_multipage_buffer *MultiPageBuffer,
@@ -842,7 +847,7 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
        return ret;
 }

-/**
+/*
  * VmbusChannelRecvPacket - Retrieve the user packet on the specified channel
  */
 /* TODO: Do we ever receive a gpa direct packet other than the ones we send ? */
@@ -908,7 +913,7 @@ int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,
        return 0;
 }

-/**
+/*
  * VmbusChannelRecvPacketRaw - Retrieve the raw packet on the specified channel
  */
 int VmbusChannelRecvPacketRaw(struct vmbus_channel *Channel, void *Buffer,
@@ -971,7 +976,7 @@ int VmbusChannelRecvPacketRaw(struct vmbus_channel *Channel, void *Buffer,
        return 0;
 }

-/**
+/*
  * VmbusChannelOnChannelEvent - Channel event callback
  */
 void VmbusChannelOnChannelEvent(struct vmbus_channel *Channel)
@@ -984,7 +989,7 @@ void VmbusChannelOnChannelEvent(struct vmbus_channel *Channel)
        mod_timer(&Channel->poll_timer, jiffies + usecs_to_jiffies(100));
 }

-/**
+/*
  * VmbusChannelOnTimer - Timer event callback
  */
 void VmbusChannelOnTimer(unsigned long data)
@@ -995,7 +1000,7 @@ void VmbusChannelOnTimer(unsigned long data)
                channel->OnChannelCallback(channel->ChannelCallbackContext);
 }

-/**
+/*
  * DumpVmbusChannel - Dump vmbus channel info to the console
  */
 static void DumpVmbusChannel(struct vmbus_channel *Channel)
diff --git a/drivers/staging/hv/ChannelMgmt.c b/drivers/staging/hv/ChannelMgmt.c
index ef38467..cc4b93c 100644
--- a/drivers/staging/hv/ChannelMgmt.c
+++ b/drivers/staging/hv/ChannelMgmt.c
@@ -70,7 +70,7 @@ static const struct hv_guid
        },
 };

-/**
+/*
  * AllocVmbusChannel - Allocate and initialize a vmbus channel object
  */
 struct vmbus_channel *AllocVmbusChannel(void)
@@ -96,7 +96,7 @@ struct vmbus_channel *AllocVmbusChannel(void)
        return channel;
 }

-/**
+/*
  * ReleaseVmbusChannel - Release the vmbus channel object itself
  */
 static inline void ReleaseVmbusChannel(void *context)
@@ -114,7 +114,7 @@ static inline void ReleaseVmbusChannel(void *context)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * FreeVmbusChannel - Release the resources used by the vmbus channel object
  */
 void FreeVmbusChannel(struct vmbus_channel *Channel)
@@ -130,7 +130,7 @@ void FreeVmbusChannel(struct vmbus_channel *Channel)
                              Channel);
 }

-/**
+/*
  * VmbusChannelProcessOffer - Process the offer by creating a channel/device associated with this offer
  */
 static void VmbusChannelProcessOffer(void *context)
@@ -212,7 +212,7 @@ static void VmbusChannelProcessOffer(void *context)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelProcessRescindOffer - Rescind the offer by initiating a device removal
  */
 static void VmbusChannelProcessRescindOffer(void *context)
@@ -224,7 +224,7 @@ static void VmbusChannelProcessRescindOffer(void *context)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelOnOffer - Handler for channel offers from vmbus in parent partition.
  *
  * We ignore all offers except network and storage offers. For each network and
@@ -307,7 +307,7 @@ static void VmbusChannelOnOffer(struct vmbus_channel_message_header *hdr)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelOnOfferRescind - Rescind offer handler.
  *
  * We queue a work item to process this offer synchronously
@@ -334,7 +334,7 @@ static void VmbusChannelOnOfferRescind(struct vmbus_channel_message_header *hdr)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelOnOffersDelivered - This is invoked when all offers have been delivered.
  *
  * Nothing to do here.
@@ -346,7 +346,7 @@ static void VmbusChannelOnOffersDelivered(
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelOnOpenResult - Open result handler.
  *
  * This is invoked when we received a response to our channel open request.
@@ -394,7 +394,7 @@ static void VmbusChannelOnOpenResult(struct vmbus_channel_message_header *hdr)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelOnGpadlCreated - GPADL created handler.
  *
  * This is invoked when we received a response to our gpadl create request.
@@ -446,7 +446,7 @@ static void VmbusChannelOnGpadlCreated(struct vmbus_channel_message_header *hdr)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelOnGpadlTorndown - GPADL torndown handler.
  *
  * This is invoked when we received a response to our gpadl teardown request.
@@ -494,7 +494,7 @@ static void VmbusChannelOnGpadlTorndown(
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelOnVersionResponse - Version response handler
  *
  * This is invoked when we received a response to our initiate contact request.
@@ -557,7 +557,7 @@ static struct vmbus_channel_message_table_entry
        {ChannelMessageUnload,                  NULL},
 };

-/**
+/*
  * VmbusOnChannelMessage - Handler for channel protocol messages.
  *
  * This is invoked in the vmbus worker thread context.
@@ -596,7 +596,7 @@ void VmbusOnChannelMessage(void *Context)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusChannelRequestOffers - Send a request to get all our pending offers.
  */
 int VmbusChannelRequestOffers(void)
@@ -650,8 +650,9 @@ Cleanup:
        return ret;
 }

-/**
- * VmbusChannelReleaseUnattachedChannels - Release channels that are unattached/unconnected ie (no drivers associated)
+/*
+ * VmbusChannelReleaseUnattachedChannels - Release channels that are
+ * unattached/unconnected ie (no drivers associated)
  */
 void VmbusChannelReleaseUnattachedChannels(void)
 {
diff --git a/drivers/staging/hv/Connection.c b/drivers/staging/hv/Connection.c
index 43c2e68..894aa37 100644
--- a/drivers/staging/hv/Connection.c
+++ b/drivers/staging/hv/Connection.c
@@ -33,7 +33,7 @@ struct VMBUS_CONNECTION gVmbusConnection = {
        .NextGpadlHandle        = ATOMIC_INIT(0xE1E10),
 };

-/**
+/*
  * VmbusConnect - Sends a connect request on the partition service connection
  */
 int VmbusConnect(void)
@@ -179,7 +179,7 @@ Cleanup:
        return ret;
 }

-/**
+/*
  * VmbusDisconnect - Sends a disconnect request on the partition service connection
  */
 int VmbusDisconnect(void)
@@ -217,7 +217,7 @@ Cleanup:
        return ret;
 }

-/**
+/*
  * GetChannelFromRelId - Get the channel object given its child relative id (ie channel id)
  */
 struct vmbus_channel *GetChannelFromRelId(u32 relId)
@@ -238,7 +238,7 @@ struct vmbus_channel *GetChannelFromRelId(u32 relId)
        return foundChannel;
 }

-/**
+/*
  * VmbusProcessChannelEvent - Process a channel event notification
  */
 static void VmbusProcessChannelEvent(void *context)
@@ -266,7 +266,7 @@ static void VmbusProcessChannelEvent(void *context)
        }
 }

-/**
+/*
  * VmbusOnEvents - Handler for events
  */
 void VmbusOnEvents(void)
@@ -307,7 +307,7 @@ void VmbusOnEvents(void)
        return;
 }

-/**
+/*
  * VmbusPostMessage - Send a msg on the vmbus's message connection
  */
 int VmbusPostMessage(void *buffer, size_t bufferLen)
@@ -319,7 +319,7 @@ int VmbusPostMessage(void *buffer, size_t bufferLen)
        return HvPostMessage(connId, 1, buffer, bufferLen);
 }

-/**
+/*
  * VmbusSetEvent - Send an event notification to the parent
  */
 int VmbusSetEvent(u32 childRelId)
diff --git a/drivers/staging/hv/Hv.c b/drivers/staging/hv/Hv.c
index 51149e6..9bee568 100644
--- a/drivers/staging/hv/Hv.c
+++ b/drivers/staging/hv/Hv.c
@@ -34,7 +34,7 @@ struct hv_context gHvContext = {
        .SignalEventBuffer      = NULL,
 };

-/**
+/*
  * HvQueryHypervisorPresence - Query the cpuid for presense of windows hypervisor
  */
 static int HvQueryHypervisorPresence(void)
@@ -55,7 +55,7 @@ static int HvQueryHypervisorPresence(void)
        return ecx & HV_PRESENT_BIT;
 }

-/**
+/*
  * HvQueryHypervisorInfo - Get version info of the windows hypervisor
  */
 static int HvQueryHypervisorInfo(void)
@@ -124,7 +124,7 @@ static int HvQueryHypervisorInfo(void)
        return maxLeaf;
 }

-/**
+/*
  * HvDoHypercall - Invoke the specified hypercall
  */
 static u64 HvDoHypercall(u64 Control, void *Input, void *Output)
@@ -179,7 +179,7 @@ static u64 HvDoHypercall(u64 Control, void *Input, void *Output)
 #endif /* !x86_64 */
 }

-/**
+/*
  * HvInit - Main initialization routine.
  *
  * This routine must be called before any other routines in here are called
@@ -293,7 +293,7 @@ Cleanup:
        return ret;
 }

-/**
+/*
  * HvCleanup - Cleanup routine.
  *
  * This routine is called normally during driver unloading or exiting.
@@ -320,7 +320,7 @@ void HvCleanup(void)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * HvPostMessage - Post a message using the hypervisor message IPC.
  *
  * This involves a hypercall.
@@ -361,7 +361,7 @@ u16 HvPostMessage(union hv_connection_id connectionId,
 }


-/**
+/*
  * HvSignalEvent - Signal an event on the specified connection using the hypervisor event IPC.
  *
  * This involves a hypercall.
@@ -375,7 +375,7 @@ u16 HvSignalEvent(void)
        return status;
 }

-/**
+/*
  * HvSynicInit - Initialize the Synthethic Interrupt Controller.
  *
  * If it is already initialized by another entity (ie x2v shim), we need to
@@ -481,7 +481,7 @@ Cleanup:
        return;
 }

-/**
+/*
  * HvSynicCleanup - Cleanup routine for HvSynicInit().
  */
 void HvSynicCleanup(void *arg)
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index 1c717f9..bd739ac 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -166,7 +166,7 @@ static struct netvsc_device *ReleaseInboundNetDevice(struct hv_device *Device)
        return netDevice;
 }

-/**
+/*
  * NetVscInitialize - Main entry point
  */
 int NetVscInitialize(struct hv_driver *drv)
@@ -704,7 +704,7 @@ static void NetVscDisconnectFromVsp(struct netvsc_device *NetDevice)
        DPRINT_EXIT(NETVSC);
 }

-/**
+/*
  * NetVscOnDeviceAdd - Callback when the device belonging to this driver is added
  */
 static int NetVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
@@ -806,7 +806,7 @@ Cleanup:
        return ret;
 }

-/**
+/*
  * NetVscOnDeviceRemove - Callback when the root bus device is removed
  */
 static int NetVscOnDeviceRemove(struct hv_device *Device)
@@ -863,7 +863,7 @@ static int NetVscOnDeviceRemove(struct hv_device *Device)
        return 0;
 }

-/**
+/*
  * NetVscOnCleanup - Perform any cleanup when the driver is removed
  */
 static void NetVscOnCleanup(struct hv_driver *drv)
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 38ea140..5a09d08 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -532,7 +532,7 @@ static int StorVscConnectToVsp(struct hv_device *Device)
        return ret;
 }

-/**
+/*
  * StorVscOnDeviceAdd - Callback when the device belonging to this driver is added
  */
 static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
@@ -584,7 +584,7 @@ Cleanup:
        return ret;
 }

-/**
+/*
  * StorVscOnDeviceRemove - Callback when the our device is being removed
  */
 static int StorVscOnDeviceRemove(struct hv_device *Device)
@@ -682,7 +682,7 @@ Cleanup:
        return ret;
 }

-/**
+/*
  * StorVscOnIORequest - Callback to initiate an I/O request
  */
 static int StorVscOnIORequest(struct hv_device *Device,
@@ -782,7 +782,7 @@ static int StorVscOnIORequest(struct hv_device *Device,
        return ret;
 }

-/**
+/*
  * StorVscOnCleanup - Perform any cleanup when the driver is removed
  */
 static void StorVscOnCleanup(struct hv_driver *Driver)
@@ -791,7 +791,7 @@ static void StorVscOnCleanup(struct hv_driver *Driver)
        DPRINT_EXIT(STORVSC);
 }

-/**
+/*
  * StorVscInitialize - Main entry point
  */
 int StorVscInitialize(struct hv_driver *Driver)
diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
index dbfbde9..78d957e 100644
--- a/drivers/staging/hv/TODO
+++ b/drivers/staging/hv/TODO
@@ -1,6 +1,5 @@
 TODO:
        - fix remaining checkpatch warnings and errors
-       - use of /** when it is not a kerneldoc header
        - remove RingBuffer.c to us in-kernel ringbuffer functions instead.
        - audit the vmbus to verify it is working properly with the
          driver model
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index 3d0a240..9a6a340 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -51,7 +51,7 @@ static const struct hv_guid gVmbusDeviceId = {
 static struct hv_driver *gDriver; /* vmbus driver object */
 static struct hv_device *gDevice; /* vmbus root device */

-/**
+/*
  * VmbusGetChannelOffers - Retrieve the channel offers from the parent partition
  */
 static void VmbusGetChannelOffers(void)
@@ -61,7 +61,7 @@ static void VmbusGetChannelOffers(void)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusGetChannelInterface - Get the channel interface
  */
 static void VmbusGetChannelInterface(struct vmbus_channel_interface *Interface)
@@ -69,7 +69,7 @@ static void VmbusGetChannelInterface(struct vmbus_channel_interface *Interface)
        GetChannelInterface(Interface);
 }

-/**
+/*
  * VmbusGetChannelInfo - Get the device info for the specified device object
  */
 static void VmbusGetChannelInfo(struct hv_device *DeviceObject,
@@ -78,7 +78,7 @@ static void VmbusGetChannelInfo(struct hv_device *DeviceObject,
        GetChannelInfo(DeviceObject, DeviceInfo);
 }

-/**
+/*
  * VmbusCreateChildDevice - Creates the child device on the bus that represents the channel offer
  */
 struct hv_device *VmbusChildDeviceCreate(struct hv_guid *DeviceType,
@@ -91,7 +91,7 @@ struct hv_device *VmbusChildDeviceCreate(struct hv_guid *DeviceType,
                                                Context);
 }

-/**
+/*
  * VmbusChildDeviceAdd - Registers the child device with the vmbus
  */
 int VmbusChildDeviceAdd(struct hv_device *ChildDevice)
@@ -101,7 +101,7 @@ int VmbusChildDeviceAdd(struct hv_device *ChildDevice)
        return vmbusDriver->OnChildDeviceAdd(gDevice, ChildDevice);
 }

-/**
+/*
  * VmbusChildDeviceRemove Unregisters the child device from the vmbus
  */
 void VmbusChildDeviceRemove(struct hv_device *ChildDevice)
@@ -111,7 +111,7 @@ void VmbusChildDeviceRemove(struct hv_device *ChildDevice)
        vmbusDriver->OnChildDeviceRemove(ChildDevice);
 }

-/**
+/*
  * VmbusOnDeviceAdd - Callback when the root bus device is added
  */
 static int VmbusOnDeviceAdd(struct hv_device *dev, void *AdditionalInfo)
@@ -140,7 +140,7 @@ static int VmbusOnDeviceAdd(struct hv_device *dev, void *AdditionalInfo)
        return ret;
 }

-/**
+/*
  * VmbusOnDeviceRemove - Callback when the root bus device is removed
  */
 static int VmbusOnDeviceRemove(struct hv_device *dev)
@@ -156,7 +156,7 @@ static int VmbusOnDeviceRemove(struct hv_device *dev)
        return ret;
 }

-/**
+/*
  * VmbusOnCleanup - Perform any cleanup when the driver is removed
  */
 static void VmbusOnCleanup(struct hv_driver *drv)
@@ -168,7 +168,7 @@ static void VmbusOnCleanup(struct hv_driver *drv)
        DPRINT_EXIT(VMBUS);
 }

-/**
+/*
  * VmbusOnMsgDPC - DPC routine to handle messages from the hypervisior
  */
 static void VmbusOnMsgDPC(struct hv_driver *drv)
@@ -216,7 +216,7 @@ static void VmbusOnMsgDPC(struct hv_driver *drv)
        }
 }

-/**
+/*
  * VmbusOnEventDPC - DPC routine to handle events from the hypervisior
  */
 static void VmbusOnEventDPC(struct hv_driver *drv)
@@ -225,7 +225,7 @@ static void VmbusOnEventDPC(struct hv_driver *drv)
        VmbusOnEvents();
 }

-/**
+/*
  * VmbusOnISR - ISR routine
  */
 static int VmbusOnISR(struct hv_driver *drv)
@@ -263,7 +263,7 @@ static int VmbusOnISR(struct hv_driver *drv)
        return ret;
 }

-/**
+/*
  * VmbusInitialize - Main entry point
  */
 int VmbusInitialize(struct hv_driver *drv)
diff --git a/drivers/staging/hv/VmbusApi.h b/drivers/staging/hv/VmbusApi.h
index d089bb1..d2d04bc 100644
--- a/drivers/staging/hv/VmbusApi.h
+++ b/drivers/staging/hv/VmbusApi.h
@@ -84,6 +84,24 @@ struct hv_device_info {
        struct hv_dev_port_info Outbound;
 };

+/**
+ * struct vmbus_channel_interface - Contains member functions for vmbus channel
+ * @Open:      Open the channel
+ * @Close:     Close the channel
+ * @SendPacket:        Send a packet over the channel
+ * @SendPacketPageBuffer:      Send a single page buffer over the channel
+ * @SendPacketMultiPageBuffer: Send a multiple page buffers
+ * @RecvPacket:        Receive packet
+ * @RecvPacketRaw:     Receive Raw packet
+ * @EstablishGpadl:    Set up GPADL for ringbuffer
+ * @TeardownGpadl:     Teardown GPADL for ringbuffer
+ * @GetInfo:   Get info about the channel
+ *
+ * This structure contains function pointer to control vmbus channel
+ * behavior. None of these functions is externally callable, but they
+ * are used for normal vmbus channel internal behavior.
+ * Only used by Hyper-V drivers.
+ */
 struct vmbus_channel_interface {
        int (*Open)(struct hv_device *Device, u32 SendBufferSize,
                    u32 RecvRingBufferSize, void *UserData, u32 UserDataLen,
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index abeac12..c90a6aa 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -164,7 +164,7 @@ static struct block_device_operations block_ops = {
        .ioctl  = blkvsc_ioctl,
 };

-/**
+/*
  * blkvsc_drv_init -  BlkVsc driver initialization.
  */
 static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
@@ -244,7 +244,7 @@ static void blkvsc_drv_exit(void)
        return;
 }

-/**
+/*
  * blkvsc_probe - Add a new device for this driver
  */
 static int blkvsc_probe(struct device *device)
@@ -732,7 +732,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
        return 0;
 }

-/**
+/*
  * blkvsc_remove() - Callback when our device is removed
  */
 static int blkvsc_remove(struct device *device)
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 1af3dcb..8b188d4 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -265,7 +265,7 @@ retry_send:
        return ret;
 }

-/**
+/*
  * netvsc_linkstatus_callback - Link up/down notification
  */
 static void netvsc_linkstatus_callback(struct hv_device *device_obj,
@@ -292,8 +292,9 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
        DPRINT_EXIT(NETVSC_DRV);
 }

-/**
- * netvsc_recv_callback -  Callback when we receive a packet from the "wire" on the specified device.
+/*
+ * netvsc_recv_callback -  Callback when we receive a packet from the
+ * "wire" on the specified device.
  */
 static int netvsc_recv_callback(struct hv_device *device_obj,
                                struct hv_netvsc_packet *packet)
diff --git a/drivers/staging/hv/osd.c b/drivers/staging/hv/osd.c
index 3a4793a..6b785e6 100644
--- a/drivers/staging/hv/osd.c
+++ b/drivers/staging/hv/osd.c
@@ -58,6 +58,15 @@ void *osd_VirtualAllocExec(unsigned int size)
 #endif
 }

+/**
+ * osd_PageAlloc() - Allocate pages
+ * @count:      Total number of Kernel pages you want to allocate
+ *
+ * Tries to allocate @count number of consecutive free kernel pages.
+ * And if successful, it will set the pages to 0 before returning.
+ * If successfull it will return pointer to the @count pages.
+ * Mainly used by Hyper-V drivers.
+ */
 void *osd_PageAlloc(unsigned int count)
 {
        void *p;
@@ -77,6 +86,14 @@ void *osd_PageAlloc(unsigned int count)
 }
 EXPORT_SYMBOL_GPL(osd_PageAlloc);

+/**
+ * osd_PageFree() - Free pages
+ * @page:       Pointer to the first page to be freed
+ * @count:      Total number of Kernel pages you free
+ *
+ * Frees the pages allocated by osd_PageAlloc()
+ * Mainly used by Hyper-V drivers.
+ */
 void osd_PageFree(void *page, unsigned int count)
 {
        free_pages((unsigned long)page, get_order(count * PAGE_SIZE));
@@ -85,6 +102,17 @@ void osd_PageFree(void *page, unsigned int count)
 }
 EXPORT_SYMBOL_GPL(osd_PageFree);

+/**
+ * osd_WaitEventCreate() - Create the event queue
+ *
+ * Allocates memory for a &struct osd_waitevent. And then calls
+ * init_waitqueue_head to set up the wait queue for the event.
+ * This structure is usually part of a another structure that contains
+ * the actual Hyper-V device driver structure.
+ *
+ * Returns pointer to &struct osd_waitevent
+ * Mainly used by Hyper-V drivers.
+ */
 struct osd_waitevent *osd_WaitEventCreate(void)
 {
        struct osd_waitevent *wait = kmalloc(sizeof(struct osd_waitevent),
@@ -98,6 +126,19 @@ struct osd_waitevent *osd_WaitEventCreate(void)
 }
 EXPORT_SYMBOL_GPL(osd_WaitEventCreate);

+
+/**
+ * osd_WaitEventSet() - Wake up the process
+ * @waitEvent: Structure to event to be woken up
+ *
+ * @waitevent is of type &struct osd_waitevent
+ *
+ * Wake up the sleeping process so it can do some work.
+ * And set condition indicator in &struct osd_waitevent to indicate
+ * the process is in a woken state.
+ *
+ * Only used by Network and Storage Hyper-V drivers.
+ */
 void osd_WaitEventSet(struct osd_waitevent *waitEvent)
 {
        waitEvent->condition = 1;
@@ -105,6 +146,20 @@ void osd_WaitEventSet(struct osd_waitevent *waitEvent)
 }
 EXPORT_SYMBOL_GPL(osd_WaitEventSet);

+/**
+ * osd_WaitEventWait() - Wait for event till condition is true
+ * @waitEvent: Structure to event to be put to sleep
+ *
+ * @waitevent is of type &struct osd_waitevent
+ *
+ * Set up the process to sleep until waitEvent->condition get true.
+ * And set condition indicator in &struct osd_waitevent to indicate
+ * the process is in a sleeping state.
+ *
+ * Returns the status of 'wait_event_interruptible()' system call
+ *
+ * Mainly used by Hyper-V drivers.
+ */
 int osd_WaitEventWait(struct osd_waitevent *waitEvent)
 {
        int ret = 0;
@@ -116,6 +171,21 @@ int osd_WaitEventWait(struct osd_waitevent *waitEvent)
 }
 EXPORT_SYMBOL_GPL(osd_WaitEventWait);

+/**
+ * osd_WaitEventWaitEx() - Wait for event or timeout for process wakeup
+ * @waitEvent: Structure to event to be put to sleep
+ * @TimeoutInMs:       Total number of Milliseconds to wait before waking up
+ *
+ * @waitevent is of type &struct osd_waitevent
+ * Set up the process to sleep until @waitEvent->condition get true or
+ * @TimeoutInMs (Time out in Milliseconds) has been reached.
+ * And set condition indicator in &struct osd_waitevent to indicate
+ * the process is in a sleeping state.
+ *
+ * Returns the status of 'wait_event_interruptible_timeout()' system call
+ *
+ * Mainly used by Hyper-V drivers.
+ */
 int osd_WaitEventWaitEx(struct osd_waitevent *waitEvent, u32 TimeoutInMs)
 {
        int ret = 0;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3988f4b..7676ba5 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -129,7 +129,7 @@ static struct scsi_host_template scsi_driver = {
 };


-/**
+/*
  * storvsc_drv_init - StorVsc driver initialization.
  */
 static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
@@ -222,7 +222,7 @@ static void storvsc_drv_exit(void)
        return;
 }

-/**
+/*
  * storvsc_probe - Add a new device for this driver
  */
 static int storvsc_probe(struct device *device)
@@ -318,7 +318,7 @@ static int storvsc_probe(struct device *device)
        return ret;
 }

-/**
+/*
  * storvsc_remove - Callback when our device is removed
  */
 static int storvsc_remove(struct device *device)
@@ -371,7 +371,7 @@ static int storvsc_remove(struct device *device)
        return ret;
 }

-/**
+/*
  * storvsc_commmand_completion - Command completion processing
  */
 static void storvsc_commmand_completion(struct hv_storvsc_request *request)
@@ -622,7 +622,7 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
        return total_copied;
 }

-/**
+/*
  * storvsc_queuecommand - Initiate command processing
  */
 static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
@@ -823,7 +823,7 @@ static int storvsc_merge_bvec(struct request_queue *q,
        return bvec->bv_len;
 }

-/**
+/*
  * storvsc_device_configure - Configure the specified scsi device
  */
 static int storvsc_device_alloc(struct scsi_device *sdevice)
@@ -862,7 +862,7 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
        return 0;
 }

-/**
+/*
  * storvsc_host_reset_handler - Reset the scsi HBA
  */
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 2c90619..177f565 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -128,7 +128,7 @@ static struct vmbus_driver_context g_vmbus_drv = {
        .bus.dev_attrs =        vmbus_device_attrs,
 };

-/**
+/*
  * vmbus_show_device_attr - Show the device attribute in sysfs.
  *
  * This is invoked when user does a
@@ -232,7 +232,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
        }
 }

-/**
+/*
  * vmbus_bus_init -Main vmbus driver initialization routine.
  *
  * Here, we
@@ -361,7 +361,7 @@ cleanup:
        return ret;
 }

-/**
+/*
  * vmbus_bus_exit - Terminate the vmbus driver.
  *
  * This routine is opposite of vmbus_bus_init()
@@ -397,8 +397,18 @@ static void vmbus_bus_exit(void)
        return;
 }

+
 /**
- * vmbus_child_driver_register - Register a vmbus's child driver
+ * vmbus_child_driver_register() - Register a vmbus's child driver
+ * @driver_ctx:        Pointer to driver structure you want to register
+ *
+ * @driver_ctx is of type &struct driver_context
+ *
+ * Registers the given driver with Linux through the 'driver_register()' call
+ * And sets up the hyper-v vmbus handling for this driver.
+ * It will return the state of the 'driver_register()' call.
+ *
+ * Mainly used by Hyper-V drivers.
  */
 int vmbus_child_driver_register(struct driver_context *driver_ctx)
 {
@@ -424,7 +434,15 @@ int vmbus_child_driver_register(struct driver_context *driver_ctx)
 EXPORT_SYMBOL(vmbus_child_driver_register);

 /**
- * vmbus_child_driver_unregister Unregister a vmbus's child driver
+ * vmbus_child_driver_unregister() - Unregister a vmbus's child driver
+ * @driver_ctx:        Pointer to driver structure you want to un-register
+ *
+ * @driver_ctx is of type &struct driver_context
+ *
+ * Un-register the given driver with Linux through the 'driver_unregister()'
+ * call. And ungegisters the driver from the Hyper-V vmbus handler.
+ *
+ * Mainly used by Hyper-V drivers.
  */
 void vmbus_child_driver_unregister(struct driver_context *driver_ctx)
 {
@@ -442,9 +460,15 @@ void vmbus_child_driver_unregister(struct driver_context *driver_ctx)
 EXPORT_SYMBOL(vmbus_child_driver_unregister);

 /**
- * vmbus_get_interface - Get the vmbus channel interface.
+ * vmbus_get_interface() - Get the vmbus channel interface.
+ * @interface: Pointer to channel interface structure
+ *
+ * Get the Hyper-V channel used for the driver.
+ *
+ * @interface is of type &struct vmbus_channel_interface
+ * This is invoked by child/client driver that sits above vmbus.
  *
- * This is invoked by child/client driver that sits above vmbus
+ * Mainly used by Hyper-V drivers.
  */
 void vmbus_get_interface(struct vmbus_channel_interface *interface)
 {
@@ -454,7 +478,7 @@ void vmbus_get_interface(struct vmbus_channel_interface *interface)
 }
 EXPORT_SYMBOL(vmbus_get_interface);

-/**
+/*
  * vmbus_child_device_get_info - Get the vmbus child device info.
  *
  * This is invoked to display various device attributes in sysfs.
@@ -467,8 +491,9 @@ static void vmbus_child_device_get_info(struct hv_device *device_obj,
        vmbus_drv_obj->GetChannelInfo(device_obj, device_info);
 }

-/**
- * vmbus_child_device_create - Creates and registers a new child device on the vmbus.
+/*
+ * vmbus_child_device_create - Creates and registers a new child device
+ * on the vmbus.
  */
 static struct hv_device *vmbus_child_device_create(struct hv_guid *type,
                                                   struct hv_guid *instance,
@@ -522,7 +547,7 @@ static struct hv_device *vmbus_child_device_create(struct hv_guid *type,
        return child_device_obj;
 }

-/**
+/*
  * vmbus_child_device_register - Register the child device on the specified bus
  */
 static int vmbus_child_device_register(struct hv_device *root_device_obj,
@@ -570,8 +595,9 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
        return ret;
 }

-/**
- * vmbus_child_device_unregister - Remove the specified child device from the vmbus.
+/*
+ * vmbus_child_device_unregister - Remove the specified child device
+ * from the vmbus.
  */
 static void vmbus_child_device_unregister(struct hv_device *device_obj)
 {
@@ -594,7 +620,7 @@ static void vmbus_child_device_unregister(struct hv_device *device_obj)
        DPRINT_EXIT(VMBUS_DRV);
 }

-/**
+/*
  * vmbus_child_device_destroy - Destroy the specified child device on the vmbus.
  */
 static void vmbus_child_device_destroy(struct hv_device *device_obj)
@@ -604,7 +630,7 @@ static void vmbus_child_device_destroy(struct hv_device *device_obj)
        DPRINT_EXIT(VMBUS_DRV);
 }

-/**
+/*
  * vmbus_uevent - add uevent for our device
  *
  * This routine is invoked when a device is added or removed on the vmbus to
@@ -683,7 +709,7 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
        return 0;
 }

-/**
+/*
  * vmbus_match - Attempt to match the specified device to the specified driver
  */
 static int vmbus_match(struct device *device, struct device_driver *driver)
@@ -718,7 +744,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
        return match;
 }

-/**
+/*
  * vmbus_probe_failed_cb - Callback when a driver probe failed in vmbus_probe()
  *
  * We need a callback because we cannot invoked device_unregister() inside
@@ -741,7 +767,7 @@ static void vmbus_probe_failed_cb(struct work_struct *context)
        DPRINT_EXIT(VMBUS_DRV);
 }

-/**
+/*
  * vmbus_probe - Add the new vmbus's child device
  */
 static int vmbus_probe(struct device *child_device)
@@ -777,7 +803,7 @@ static int vmbus_probe(struct device *child_device)
        return ret;
 }

-/**
+/*
  * vmbus_remove - Remove a vmbus device
  */
 static int vmbus_remove(struct device *child_device)
@@ -819,7 +845,7 @@ static int vmbus_remove(struct device *child_device)
        return 0;
 }

-/**
+/*
  * vmbus_shutdown - Shutdown a vmbus device
  */
 static void vmbus_shutdown(struct device *child_device)
@@ -855,7 +881,7 @@ static void vmbus_shutdown(struct device *child_device)
        return;
 }

-/**
+/*
  * vmbus_bus_release - Final callback release of the vmbus root device
  */
 static void vmbus_bus_release(struct device *device)
@@ -869,7 +895,7 @@ static void vmbus_bus_release(struct device *device)
        DPRINT_EXIT(VMBUS_DRV);
 }

-/**
+/*
  * vmbus_device_release - Final callback release of the vmbus child device
  */
 static void vmbus_device_release(struct device *device)
@@ -887,7 +913,7 @@ static void vmbus_device_release(struct device *device)
        return;
 }

-/**
+/*
  * vmbus_msg_dpc - Tasklet routine to handle hypervisor messages
  */
 static void vmbus_msg_dpc(unsigned long data)
@@ -904,7 +930,7 @@ static void vmbus_msg_dpc(unsigned long data)
        DPRINT_EXIT(VMBUS_DRV);
 }

-/**
+/*
  * vmbus_msg_dpc - Tasklet routine to handle hypervisor events
  */
 static void vmbus_event_dpc(unsigned long data)
