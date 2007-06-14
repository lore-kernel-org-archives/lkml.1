Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbXFNWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbXFNWYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbXFNWYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:24:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:64067 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbXFNWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PVkoMKF/g62F3mEKq3LgBhNtBdvBS3Qttidiv8sYuJBCeN16HkK/N9g23g8Nd8Zkb6eG5GLAKFKTckaHALwnJv4KkjyQjK92v0YKwY4IsJ+qKuQ5dZxDHA2obPRkSwY+0Sulr6mddQPyjpk4PCYWEFMmmYyJRvik/szE7xH3q18=
Message-ID: <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com>
Date: Thu, 14 Jun 2007 23:24:00 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
	 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
	 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
	 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
	 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz>
	 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com>
	 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com>
	 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
	 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/07, Jiri Kosina <jkosina@suse.cz> wrote:
> could you please apply the stupid patch below (against 2.6.20, I know you
> are using it :) ) and report the result? It should show us whether the
> values 0 and 4096 (which can be seen in your hid parsing debug dump) are
> correctly passed from HID to input, or they are garbled inside the hid
> layer somewhere already.

Hi Jiri,

Applied your patch and the log is below,

thanks!
--renato


[ 6944.776870] input: USB HID v1.00 Joystick [Saitek Cyborg Evo Force]
on usb-0000:00:0b.0-7
[ 6944.777254] usbcore: registered new interface driver usbhid
[ 6944.790141] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[ 6973.503388] usbcore: deregistering interface driver usbhid
[ 6973.515956] usbcore: deregistering interface driver hiddev
[ 6973.565396] usbcore: registered new interface driver hiddev
[ 6973.571885] Key.LeftBtn
[ 6973.571893] Key.RightBtn
[ 6973.571901] Key.MiddleBtn
[ 6973.571909] Relative.X
[ 6973.571916] Relative.Y
[ 6973.571924] Relative.Wheel
[ 6973.573896] input: Dell Dell USB Mouse as /class/input/input40
[ 6973.574160] input: USB HID v1.10 Mouse [Dell Dell USB Mouse] on
usb-0000:00:0b.0-3
[ 6973.587817] hid-debug: input GenericDesktop.X = 2056
[ 6973.587824] hid-debug: input GenericDesktop.Y = 2064
[ 6973.587829] hid-debug: input Simulation.Throttle = 130
[ 6973.587834] hid-debug: input Button.0001 = 0
[ 6973.587839] hid-debug: input Button.0002 = 0
[ 6973.587843] hid-debug: input Button.0003 = 0
[ 6973.587847] hid-debug: input Button.0004 = 0
[ 6973.587852] hid-debug: input Button.0005 = 0
[ 6973.587856] hid-debug: input Button.0006 = 0
[ 6973.587860] hid-debug: input Button.0007 = 0
[ 6973.587864] hid-debug: input Button.0008 = 0
[ 6973.587868] hid-debug: input Button.0009 = 0
[ 6973.587872] hid-debug: input Button.000a = 0
[ 6973.587876] hid-debug: input Button.000b = 0
[ 6973.587880] hid-debug: input Button.000c = 0
[ 6973.587885] hid-debug: input GenericDesktop.HatSwitch = 15
[ 6973.587889] hid-debug: input Simulation.Rudder = 255
[ 6973.588816] hid-debug: input PhysicalInterfaceDevice.00a6 = 1
[ 6973.588823] hid-debug: input PhysicalInterfaceDevice.00a4 = 1
[ 6973.588827] hid-debug: input PhysicalInterfaceDevice.00a0 = 0
[ 6973.588832] hid-debug: input PhysicalInterfaceDevice.009f = 0
[ 6973.588837] hid-debug: input PhysicalInterfaceDevice.0022 = 7
[ 6973.588841] hid-debug: input PhysicalInterfaceDevice.0094 = 0
[ 6973.589816] hid-debug: input PhysicalInterfaceDevice.0080 = 300
[ 6973.589822] hid-debug: input PhysicalInterfaceDevice.00a9 = 0
[ 6973.589826] hid-debug: input PhysicalInterfaceDevice.0083 = 10
[ 6973.589831] hid-debug: input PhysicalInterfaceDevice.0084 = 2
[ 6973.589836] hid-debug: input PhysicalInterfaceDevice.0073 = 1
[ 6973.589841] hid-debug: input PhysicalInterfaceDevice.006e = 12
[ 6973.589845] hid-debug: input PhysicalInterfaceDevice.005a = 12
[ 6973.589850] hid-debug: input PhysicalInterfaceDevice.005f = 8
[ 6973.596010] calling input_set_abs_params, code: 0, min: 0, max:
1000, fuzz: 10, flat: 100
[ 6973.596013] Absolute.X
[ 6973.596022] calling input_set_abs_params, code: 1, min: 0, max:
1000, fuzz: 10, flat: 100
[ 6973.596024] Absolute.Y
[ 6973.596033] calling input_set_abs_params, code: 6, min: 0, max: ff,
fuzz: 0, flat: f
[ 6973.596035] Absolute.Throttle
[ 6973.596043] Key.Trigger
[ 6973.596050] Key.ThumbBtn
[ 6973.596058] Key.ThumbBtn2
[ 6973.596070] Key.TopBtn
[ 6973.596077] Key.TopBtn2
[ 6973.596084] Key.PinkieBtn
[ 6973.596091] Key.BaseBtn
[ 6973.596099] Key.BaseBtn2
[ 6973.596106] Key.BaseBtn3
[ 6973.596113] Key.BaseBtn4
[ 6973.596120] Key.BaseBtn5
[ 6973.596128] Key.BaseBtn6
[ 6973.596136] calling input_set_abs_params, code: 10, min: 0, max: 7,
fuzz: 0, flat: 0
[ 6973.596139] Absolute.Hat0X
[ 6973.596147] calling input_set_abs_params, code: 7, min: 0, max: ff,
fuzz: 0, flat: f
[ 6973.596149] Absolute.Rudder
[ 6973.596157] IGNORED
[ 6973.596165] Key.BtnDead
[ 6973.596172] IGNORED
[ 6973.596180] IGNORED
[ 6973.596187] IGNORED
[ 6973.596194] IGNORED
[ 6973.596201] IGNORED
[ 6973.596208] IGNORED
[ 6973.596215] IGNORED
[ 6973.596223] IGNORED
[ 6973.596230] IGNORED
[ 6973.596237] IGNORED
[ 6973.596244] IGNORED
[ 6973.596251] IGNORED
[ 6973.596258] IGNORED
[ 6973.596265] IGNORED
[ 6973.596272] IGNORED
[ 6973.596280] calling input_set_abs_params, code: 0, min: 0, max: 1,
fuzz: 0, flat: 0
[ 6973.596282] Absolute.X
[ 6973.596290] calling input_set_abs_params, code: 1, min: 0, max: 1,
fuzz: 0, flat: 0
[ 6973.596292] Absolute.Y
[ 6973.596300] IGNORED
[ 6973.596307] IGNORED
[ 6973.596314] IGNORED
[ 6973.596322] calling input_set_abs_params, code: 28, min: 0, max:
12b, fuzz: 1, flat: 12
[ 6973.596324] Absolute.Misc
[ 6973.596333] calling input_set_abs_params, code: 29, min: 0, max:
12b, fuzz: 1, flat: 12
[ 6973.596335] Absolute.?
[ 6973.596343] IGNORED
[ 6973.596350] IGNORED
[ 6973.596357] IGNORED
[ 6973.596364] IGNORED
[ 6973.596371] IGNORED
[ 6973.596379] IGNORED
[ 6973.596386] IGNORED
[ 6973.596393] IGNORED
[ 6973.596400] IGNORED
[ 6973.596407] IGNORED
[ 6973.596415] IGNORED
[ 6973.596422] IGNORED
[ 6973.596429] IGNORED
[ 6973.596436] IGNORED
[ 6973.596444] IGNORED
[ 6973.596451] IGNORED
[ 6973.596458] IGNORED
[ 6973.596465] IGNORED
[ 6973.596472] IGNORED
[ 6973.596479] IGNORED
[ 6973.596486] IGNORED
[ 6973.596493] IGNORED
[ 6973.596500] IGNORED
[ 6973.596508] IGNORED
[ 6973.596515] IGNORED
[ 6973.596522] IGNORED
[ 6973.596529] IGNORED
[ 6973.596536] IGNORED
[ 6973.596543] IGNORED
[ 6973.596550] IGNORED
[ 6973.596557] IGNORED
[ 6973.596565] IGNORED
[ 6973.596573] IGNORED
[ 6973.596580] IGNORED
[ 6973.596588] IGNORED
[ 6973.596595] IGNORED
[ 6973.596603] IGNORED
[ 6973.596610] IGNORED
[ 6973.596618] IGNORED
[ 6973.596625] IGNORED
[ 6973.596633] IGNORED
[ 6973.596640] IGNORED
[ 6973.596648] IGNORED
[ 6973.596655] IGNORED
[ 6973.596663] IGNORED
[ 6973.596670] IGNORED
[ 6973.596678] IGNORED
[ 6973.596685] IGNORED
[ 6973.596692] IGNORED
[ 6973.596699] IGNORED
[ 6973.596707] IGNORED
[ 6973.596714] IGNORED
[ 6973.596722] calling input_set_abs_params, code: 0, min: ffffff81,
max: 7f, fuzz: 0, flat: f
[ 6973.596724] Absolute.X
[ 6973.596732] calling input_set_abs_params, code: 1, min: ffffff81,
max: 7f, fuzz: 0, flat: f
[ 6973.596735] Absolute.Y
