Return-Path: <linux-kernel-owner+w=401wt.eu-S1423228AbXBUWsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423228AbXBUWsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423234AbXBUWsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:48:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:37904 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423228AbXBUWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:48:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l4fConEC7OPuVjn7US+S1fPf33Voe4er3gLNKi8aWxgMx5Biqo6iK1oIbl4zgForrJoaa3ucXOIqjf+AAXw3QcrM2keCyTn8CbFTx8BQNsohtjTWsSc48T9APcORQTpB3n9/thIXmQG5WMVemrtmJQlZ4yKvPBJFI83HSu1Jtwo=
Message-ID: <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
Date: Wed, 21 Feb 2007 17:48:08 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: Re: Phis in /proc/bus/input/devices same for all devices?
Cc: CIJOML <cijoml@volny.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <1172097890.7403.52.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702212313.30359.cijoml@volny.cz>
	 <d120d5000702211427y423acfdekb83343a4f90caab0@mail.gmail.com>
	 <1172097890.7403.52.camel@violet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dmitry,
>
> > > can anybody reply to this and share his/her opinion?
> >
> > Input core already exports uniq to udev and also via sysfs.
>
> so do you think it would be better to create phys as a string of the
> source and destination address like "<src>-<dst>" for Bluetooth. And
> then keep the uniq empty like all USB devices without serial number do?
>

I'd keep uniq as is and do what you proposed with phys. This way you
can either use uniq to identify your device while moving it from one
receiver to another (if you have several) or do exact match on phys to
get receiver/device pair.

Does this make sense?

-- 
Dmitry
