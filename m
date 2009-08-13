Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZHMP4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZHMP4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZHMP4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:56:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:29030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZHMP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent:message-id;
        b=Nf2XuvGOiM8GQvRtiCGSbgPDd2cXB+bZoqQ4Bk9ULvj8wJaD32vq7iUYTt4JMpeC81
         2LwuooGVKg/NaNf/NYXEqxK+LXoxYeR4zF1a4aBDGGTdC7kbo0SSr7N5ws/VIA2HlJBP
         4inK2/A0mWI6SX6B1dXLeNHc822dRQg28Qjb4=
Date: Thu, 13 Aug 2009 08:56:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       bjorn.helgaas@hp.com, randy.dunlap@oracle.com
Subject: Re: [patch 2/2] Add a driver for the Winbond WPCD376I Consumer IR
	hardware
References: <20090809095645.198777507@hardeman.nu> <20090809095744.090206173@hardeman.nu> <20090813072905.56FB4526EC9@mailhub.coreip.homeip.net> <d92044dd553973571c2dd5cb18a925f9.squirrel@www.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d92044dd553973571c2dd5cb18a925f9.squirrel@www.hardeman.nu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090813162726.DBD9A526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:34:44AM +0200, David Härdeman wrote:
> On Thu, August 13, 2009 08:58, Dmitry Torokhov wrote:
> > Hi David,
> 
> Hi,
> 
> > Please keep Makefile sorted alphabetically.
> 
> Ok
> 
> >> +static struct wbcir_key rc6_def_keymap[] = {
> >> +	{ 0x800F0400, KEY_0			},
> >> +	{ 0x800F0401, KEY_1			},
> >> +	{ 0x800F0402, KEY_2			},
> >> +	{ 0x800F0403, KEY_3			},
> >> +	{ 0x800F0404, KEY_4			},
> >> +	{ 0x800F0405, KEY_5			},
> >> +	{ 0x800F0406, KEY_6			},
> >> +	{ 0x800F0407, KEY_7			},
> >> +	{ 0x800F0408, KEY_8			},
> >> +	{ 0x800F0409, KEY_9			},
> >
> > Make these ones KEY_NUMERIC_* as well, this should help users whose
> > keymaps have numbers in upper register normally.
> 
> Ok
> 
> >> +	{ 0x800F041D, KEY_NUMERIC_STAR		},
> >> +	{ 0x800F041C, KEY_NUMERIC_POUND		},
> >> +	{ 0x800F0410, KEY_VOLUMEUP		},
> >> +	{ 0x800F0411, KEY_VOLUMEDOWN		},
> >> +	{ 0x800F0412, KEY_CHANNELUP		},
> >> +	{ 0x800F0413, KEY_CHANNELDOWN		},
> >> +	{ 0x800F040E, KEY_MUTE			},
> >> +	{ 0x800F040D, KEY_VENDOR		}, /* Vista Logo Key */
> >> +	{ 0x800F041E, KEY_UP			},
> >> +	{ 0x800F041F, KEY_DOWN			},
> >> +	{ 0x800F0420, KEY_LEFT			},
> >> +	{ 0x800F0421, KEY_RIGHT			},
> >> +	{ 0x800F0422, KEY_OK			},
> >> +	{ 0x800F0423, KEY_ESC			},
> >> +	{ 0x800F040F, KEY_INFO			},
> >> +	{ 0x800F040A, KEY_CLEAR			},
> >> +	{ 0x800F040B, KEY_ENTER			},
> >> +	{ 0x800F045B, KEY_RED			},
> >> +	{ 0x800F045C, KEY_GREEN			},
> >> +	{ 0x800F045D, KEY_YELLOW		},
> >> +	{ 0x800F045E, KEY_BLUE			},
> >> +	{ 0x800F045A, KEY_TEXT			},
> >> +	{ 0x800F0427, KEY_SWITCHVIDEOMODE	},
> >> +	{ 0x800F040C, KEY_POWER			},
> >> +	{ 0x800F0450, KEY_RADIO			},
> >> +	{ 0x800F0448, KEY_PVR			},
> >> +	{ 0x800F0447, KEY_AUDIO			},
> >> +	{ 0x800F0426, KEY_EPG			},
> >> +	{ 0x800F0449, KEY_CAMERA		},
> >> +	{ 0x800F0425, KEY_TV			},
> >> +	{ 0x800F044A, KEY_VIDEO			},
> >> +	{ 0x800F0424, KEY_DVD			},
> >> +	{ 0x800F0416, KEY_PLAY			},
> >> +	{ 0x800F0418, KEY_PAUSE			},
> >> +	{ 0x800F0419, KEY_STOP			},
> >> +	{ 0x800F0414, KEY_FASTFORWARD		},
> >> +	{ 0x800F041A, KEY_NEXT			},
> >> +	{ 0x800F041B, KEY_PREVIOUS		},
> >> +	{ 0x800F0415, KEY_REWIND		},
> >> +	{ 0x800F0417, KEY_RECORD		},
> >
> > Umm, it looks like if you do (code & 0x800F0400) you can switch to
> > standard array-based keymap and won't even need list manipulation.
> 
> I didn't want to do that since it would potentially tie the driver to one
> particular remote (the one I used for testing while writing the driver).
> The hardware isn't shipped with any specific remote so that wouldn't be
> very user friendly.
> 
> This was the best solution I could come up with without adding some real
> limitations to the functionality of the driver.

I see.

> 
> The main problem right now is that getkeycode is practically useless since
> you can't blindly guess at a full range of 2^32 different scancodes to get
> the complete keymap. Perhaps a index-based getkeycode would make sense...

The drivers that have such sparce keymaps are expected to issue
EV_MSC/MSC_SCAN events to aid userspace in identifying the "scancodes"
that are emitted by the device.

> 
> Anyway, I hope that I can make this a moot point in the future by adding
> more IR-specific functionality to the input system. I've been thinking
> along the lines of IR-specific get/set-keycode ioctl's which would take a
> struct which defines the IR command to map to a key.
> 
> >> +};
> >> +
> >> +/* Registers and other state is protected by wbcir_lock */
> >> +struct wbcir_data {
> >> +	unsigned long wbase;        /* Wake-Up Baseaddr		*/
> >> +	unsigned long ebase;        /* Enhanced Func. Baseaddr	*/
> >> +	unsigned long sbase;        /* Serial Port Baseaddr	*/
> >> +	unsigned int  irq;          /* Serial Port IRQ		*/
> >> +
> >> +	struct input_dev *input_dev;
> >> +	struct timer_list timer_keyup;
> >> +	struct led_trigger *rxtrigger;
> >> +	struct led_trigger *txtrigger;
> >> +	struct led_classdev led;
> >> +
> >> +	u32 last_scancode;
> >> +	unsigned int last_keycode;
> >> +	u8 last_toggle;
> >> +	u8 keypressed;
> >> +	unsigned long keyup_jiffies;
> >> +	unsigned int idle_count;
> >> +
> >> +	/* RX irdata and parsing state */
> >> +	unsigned long irdata[30];
> >> +	unsigned int irdata_count;
> >> +	unsigned int irdata_idle;
> >> +	unsigned int irdata_off;
> >> +	unsigned int irdata_error;
> >> +
> >> +	/* Protected by keytable_lock */
> >> +	struct list_head keytable;
> >
> > I think this has a potential to deadlock... Set and get keycodes are
> > called with event lock taken, and then your implementations acquire
> > keytable lock. When you emit input events the opposite happens - you
> > take the keytable lock and then input core takes event lock.
> 
> Good catch, I'll have to look into that...
> 
> >> +static struct device_attribute dev_attr_last_scancode = {
> >> +	.attr = {
> >> +		.name = "last_scancode",
> >> +		.mode = 0444,
> >> +	},
> >> +	.show = wbcir_show_last_scancode,
> >> +	.store = NULL,
> >> +
> >> +};
> >
> > Why is this needed? And if this is needed we have a nice macro
> > for that.
> 
> I hope I've explained it wrt. EV_IR in my other mail. It's for building
> keymaps of unknown remotes. And it'll go away once EV_IR is supported so I
> don't think there's much point in fiddling with it now?
> 

Because once the driver is in mainline it becomes part of userspace ABI
and has to stay for a looong time.

> >> +static int
> >> +wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
> >
> > __devinit
> >
> ...
> >> +	dev_info(&device->dev, "Found device "
> >> +		 "(w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
> >> +		 data->wbase, data->ebase, data->sbase, data->irq);
> >> +
> >
> > dev_dbg() I think.
> 
> Ok
> 
> >> +static void
> >> +wbcir_remove(struct pnp_dev *device)
> >
> > __devexit
> 
> Ok
> 
> >> +static struct pnp_driver wbcir_driver = {
> >> +	.name     = WBCIR_ACPI_NAME,
> >> +	.id_table = wbcir_ids,
> >> +	.probe    = wbcir_probe,
> >> +	.remove   = wbcir_remove,
> >
> > __devexit_p()
> 
> Ok
> 
> >> +	.suspend  = wbcir_suspend,
> >> +	.resume   = wbcir_resume,
> >
> > Switch to dev_pm_ops?
> 
> Don't want to do that just yet. dev_pm_ops wasn't even on my radar until
> yesterday when I stumbled upon the documentation (in a header file rather
> than in Documentation/...eh?). I'll certainly look into it when the
> suspend/resume functionality has seen more testing and bug fixing.
> 
> Thanks for the review. Are you willing to push the driver upstream through
> the input tree once I've implemented your suggested fixes?
>

I'd need to take a look at your EV_IR patyches and see how they will
affect this driver. I do nt want to merge something that will stay one
way for half a release and then will switch to completely new interface.

-- 
Dmitry
