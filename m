Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbZHCVO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbZHCVO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZHCVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:14:58 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47266 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZHCVO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=ZGuOJquBP2+FCKHVdDLMuYLAMPxULrtxhpqkJGNbhIzaBWaZYpI8MJU7vgk5FL5tCv
         Qr1V+nmAknrbo8tFZrwr+q/619L1LAKgl5LwWS3Hs+GpK50NoDh3MbrrGyhxLh7/8ogv
         9i7iXldVhLiBieKuqmqlzuUAyWTnUM+01AERI=
MIME-Version: 1.0
Date: Mon, 3 Aug 2009 17:14:56 -0400
X-Google-Sender-Auth: 0858c4a85ae1672c
Message-ID: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
Subject: Is anyone maintaining (or even using) usbtmc?
From: Andrew Lutomirski <luto@mit.edu>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

I'm trying to use usbtmc on an Aglient N9310A (The only TMC device I
have), and it sort of works, but it seems to be both extremely buggy
and missing a good deal of rather important functionality.  Is there
anyone maintaining it?

If the answer is yes, I can describe the bugs (logspam, spurious
errors, delayed messages, inability to read status, etc.) in greater
detail.

If the answer is no (as I suspect it is), then I might give fixing it
a shot the week after next, when I'll be camping out in Virginia with
this thing for awhile.  In that case, I have another question:

Is anyone using usbtmc, or, more specifically, does anyone care about
backward compatibility?

If not, then I'll be less careful to preserve the interface, even
though I'm not really sure that there's much of interest to preserve.

Thanks,
Andy, who's happy that the driver at least works a little bit
