Return-Path: <linux-kernel-owner+w=401wt.eu-S936161AbYEVNZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936161AbYEVNZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764441AbYEVNYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:24:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:64446 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762498AbYEVNYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=svS5rhuyCBQbuNc0xCIRln/dvvTn3z8sTKaWPo9+QBd/5rMzuAoCCXSKbupv0jfnF252xF3DbSYuTHL/81x3eUNQiWwgXExfMkVnw47wr8Mb+rTgYL2+TjDeNqKySpkrmGwAp6OyjWu+1uOGQb+xih84G4mj2lpJea5t7cxgezw=
Message-ID: <b49af93b0805220624q63ef2897vfdf5683aff97d935@mail.gmail.com>
Date: Thu, 22 May 2008 18:54:48 +0530
From: "vijay anand" <vijayanand.sj@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [BUG] cdc-acm driver module
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200805221321.37063.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b49af93b0805210601n38030150w643565b60edc85da@mail.gmail.com>
	 <200805211525.08054.oliver@neukum.org>
	 <b49af93b0805212159x46226c63i948e90e263283efc@mail.gmail.com>
	 <200805221321.37063.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much !!

On Thu, May 22, 2008 at 4:51 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Donnerstag 22 Mai 2008 06:59:50 schrieb vijay anand:
>> What happens when the function 'usb_deregister' in 'acm_exit'  gets
>> called before the control reaches the 'acm_disconnect'? Is there any
>> possibility for this? If yes what happens during this scenario?
>
> This cannot happen. The driver core will disconnect all devices bound
> to a driver to be unloaded.
>
>        Regards
>                Oliver
>
>
