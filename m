Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZGTHqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZGTHqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZGTHqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:46:32 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:61037 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZGTHqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u/+5xBZbdlxK/tqiFnI2PnE6T3rktAlut/etkT34aKfcz06n0UXahzkhkwhZ/7Z9C9
         BfF3Wr8AH7Z6ON/7RL7KBrroIgqgjRNhybSYU34pEPp0hSdgKSQQn0qPRLbr9X25ZNnw
         0S70dfFwSCMWOUizc6FZ7kKcpCefu9Wa7QAjU=
MIME-Version: 1.0
In-Reply-To: <1248074120.4549.89.camel@violet>
References: <dd18b0c30907192045t3078451ao9af4c1751d9efe91@mail.gmail.com>
	 <1248074120.4549.89.camel@violet>
Date: Mon, 20 Jul 2009 00:46:30 -0700
Message-ID: <dd18b0c30907200046m70ac61e9wd0464c5f44e7c28@mail.gmail.com>
Subject: Re: btusb_send_frame: hci0 urb ede00a50 submission failed
From: Justin Mattock <justinmattock@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 12:15 AM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi Justin,
>
>> Not sure whats happening here,
>> this morning using s2ram worked like a charm,
>> now at the end of the day this thing takes a good minute to
>> wakeup. As for the blueooth finally got it working, but
>> now I'm seeing this in dmesg:
>>
>>
>> [  708.630722] Restarting tasks ... done.
>> [  708.910090] usb 5-1: USB disconnect, address 3
>> [  708.910262] btusb_send_frame: hci0 urb ede00a50 submission failed
>> [  709.330776] [drm] Loading R500 Microcode
>>
>> Maybe suspend works better when cooler, but in anycase
>> the bluetooth works perfectly recovers from s2ram, scrollball
>> works as well(all with SELinux running too).
>
> what kernel version? Is this a plain vanilla kernel.org kernel or a
> distro kernel?
>
> Regards
>
> Marcel
>
>
>

latest git
here's a cut from dmesg:

[13176.287859] PM: Syncing filesystems ... done.
[13176.291783] Freezing user space processes ... (elapsed 0.00 seconds) done.
[13176.292142] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[13176.292275] Suspending console(s) (use no_console_suspend to debug)
[13176.294725] btusb_bulk_complete: hci0 urb f6ac6a50 failed to resubmit (1)
[13176.295720] btusb_bulk_complete: hci0 urb f6ac66e0 failed to resubmit (1)
[13176.296719] btusb_intr_complete: hci0 urb f6ac6420 failed to resubmit (1)
[13176.470263] sd 2:0:1:0: [sda] Synchronizing SCSI cache
[13176.697678] sd 2:0:1:0: [sda] Stopping disk
[13177.600230] ath9k 0000:03:00.0: PCI INT A disabled

then s2ram again:

[13182.139058] wlan0: associate with AP 00:1e:2a:00:67:f0
[13182.141361] wlan0: RX ReassocResp from 00:1e:2a:00:67:f0
(capab=0x431 status=0 aid=2)
[13182.141364] wlan0: associated
[13182.150158] usb 5-1: USB disconnect, address 7
[13182.150332] btusb_send_frame: hci0 urb f1f2c420 submission failed
[13182.561534] [drm] Loading R500 Microcode
[13182.561598] [drm] Num pipes: 1

Not sure what this is, but from here the mouse is functioning
as it should.


-- 
Justin P. Mattock
