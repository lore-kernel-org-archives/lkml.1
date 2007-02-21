Return-Path: <linux-kernel-owner+w=401wt.eu-S1423251AbXBUWsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423251AbXBUWsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423257AbXBUWso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:48:44 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:60284 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423234AbXBUWsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:48:21 -0500
From: CIJOML <cijoml@volny.cz>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Wed, 21 Feb 2007 23:48:12 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Marcel Holtmann" <marcel@holtmann.org>
References: <200702212313.30359.cijoml@volny.cz> <200702212337.18469.cijoml@volny.cz> <d120d5000702211443t4ef35436k2f32d8009289d5cb@mail.gmail.com>
In-Reply-To: <d120d5000702211443t4ef35436k2f32d8009289d5cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702212348.13044.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

there are correct values, but not in 
/proc/bus/input/devices, where is value non of my devices owns.

Michal

Dne støeda 21 únor 2007 23:43 Dmitry Torokhov napsal(a):
> On 2/21/07, CIJOML <cijoml@volny.cz> wrote:
> > So where is that damned bug, that I don't see those uniq BDADDRESSes
> > there?
> >
> > Michal
> >
> > Dne støeda 21 únor 2007 23:27 Dmitry Torokhov napsal(a):
> > > On 2/21/07, CIJOML <cijoml@volny.cz> wrote:
> > > > Hi,
> > > >
> > > > can anybody reply to this and share his/her opinion?
> > >
> > > Input core already exports uniq to udev and also via sysfs.
>
> If you cat /sys/class/input/inputX/uniq for your BT devices  - is it empty?
>
> Uniq is not exported via  /proc/bus/input/devices.
