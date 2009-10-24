Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZJXIlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZJXIlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 04:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZJXIlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 04:41:49 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40613 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZJXIls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 04:41:48 -0400
Subject: Re: [PATCH] bluetooth: remove useless variable in virtual hci
 driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1256340575-19359-1-git-send-email-cascardo@holoscopio.com>
References: <1256340575-19359-1-git-send-email-cascardo@holoscopio.com>
Content-Type: text/plain
Date: Sat, 24 Oct 2009 17:41:28 +0900
Message-Id: <1256373688.7812.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thadeu,

> Commit ac28494c has removed the option to give a minor number as
> parameter for VHCI driver. Remove the variable used for that parameter.
> Print the error code when registering the device fails, instead of the
> requested minor number (which would always be MISC_DYNAMIC_MINOR).

I see the point in removing the variable. That is clearly a leftover,
but what is the error code printing for? That is pointless since we can
just return misc_register(&vhci_miscdev); since it is the module loading
function. And in the exit module case I don't care. The misc_deregister
should not return an error to begin with. It is pointless. Fix up the
patch and re-sent it.

Regards

Marcel


