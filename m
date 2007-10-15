Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbXJOTfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbXJOTfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXJOTfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:35:44 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:49965 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756554AbXJOTfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:35:43 -0400
Date: Mon, 15 Oct 2007 21:35:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH try #3] Input/Joystick Driver: add support AD7142
 joystick driver
Message-ID: <20071015213541.25bac062@hyperion.delvare>
In-Reply-To: <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
References: <1192459625.6215.17.camel@roc-laptop>
	<d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 11:48:17 -0400, Dmitry Torokhov wrote:
> On 10/15/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > +static int __init ad7142_init(void)
> > +{
> > +       return i2c_add_driver(&ad7142_driver);
> > +}
> > +
> > +static void __exit ad7142_exit(void)
> > +{
> > +       i2c_del_driver(&ad7142_driver);
> > +       input_unregister_device(ad7142_dev);
> 
> input_unregister_device() should be in ad7142_detach_client? I am not
> sure i2c - there seems to be 2 interface styles and you probably need
> to use the new one. I am CC-inj Jean on this.

The new style is preferred, yes.

-- 
Jean Delvare
