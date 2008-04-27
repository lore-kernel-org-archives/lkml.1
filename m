Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYD0LWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYD0LWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYD0LWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:22:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:5088 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbYD0LWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bAcpknzHZ4VTaNg+ptId8l4GHyvbNCSZTUDQ7gOid414vYiSDLfFjcFniYre/MRjywJvv21ucHRW/meRtpPz0QTBUjy/pWQtw083upla3zXMGGxv/crhGedZlylOAPD+xn+MWMxaS/mDrI6ALvrYZdlR3bmOBHiHQnogxVVujRs=
Message-ID: <481461FC.8000006@gmail.com>
Date: Sun, 27 Apr 2008 13:22:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, mit-devel@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: HID bus
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz> <1208644696-29129-1-git-send-email-jirislaby@gmail.com> <480B2F9A.3020104@gmail.com> <Pine.LNX.4.64.0804220158560.12972@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0804220158560.12972@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2008 02:00 AM, Jiri Kosina wrote:
> On Sun, 20 Apr 2008, Jiri Slaby wrote:
> 
>> So I suppose we still need the option to let users compile all the 
>> chosen drivers into hid.
> 
> Another possible workaround is to introduce dummy "hid" module, that will 
> just depend on all other drivers with a reference to certail symbol (and 
> this could of course be optional as CONFIG_HID_COMPAT, or whatever).

If I understand correctly, it would create circular dependency:
hid->dummy_hid->hid_apple->hid

Is is correct?

Thanks.
