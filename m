Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYILDHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYILDHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 23:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYILDHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 23:07:35 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:52069 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbYILDHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 23:07:34 -0400
Message-ID: <48C9DCF4.7000604@lwfinger.net>
Date: Thu, 11 Sep 2008 22:07:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Steven Noonan <steven@uplinklabs.net>, LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
References: <48C9D040.8010107@lwfinger.net>	<f488382f0809111932v1cc1eb44kbe0bc0e97347c834@mail.gmail.com>	<48C9DACE.5040308@lwfinger.net> <adavdx2kqt5.fsf@cisco.com>
In-Reply-To: <adavdx2kqt5.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > This one gets rid of the sparse warning.
>  > 
>  >        priv->rx_mtu = le16_to_cpu((__le16 __force)
>  >                                   bootrec->data[10]);
> 
> Yes but does it actually work on both big and little endian systems?
> (See my previous email)

I don't know, but as my previous email stated, the code could not 
possibly have worked on a big-endian system before I started the 
sparse cleanup. I don't have access to anything but little-endian 
hardware.

Larry
