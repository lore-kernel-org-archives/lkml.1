Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYAETlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYAETlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbYAETlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:41:00 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45798 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756873AbYAETk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:40:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UsKo8LlT9jiIBrOcHWIDWCmRqlefbYm6vrzuudPXNUuhx6xrHdVUAni+iQ3+O3ZAt4ZKwNp1zfvH3V/hHaFT2vF/V+Y5+TY0i2hS4s3OwDvQO4SOsMFE7IvuipfyyDQo7BeFJwRwvcjuJkwOx7BaOjZ+jfPZGaqhSq9TIQcbokk=  ;
X-YMail-OSG: gPsFuwAVM1llsPj879J9eu8h7tiQucyshZMNkPC.L0dGUndhONs5wpDhTHl6CfPHYzZW.b_b6w--
From: David Brownell <david-b@pacbell.net>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
Date: Sat, 5 Jan 2008 10:42:09 -0800
User-Agent: KMail/1.9.6
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <200801051546.SAA08947@raad.intranet>
In-Reply-To: <200801051546.SAA08947@raad.intranet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801051042.10352.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 January 2008, Al Boldi wrote:
> +comment "NOTE: USB_STORAGE selects SCSI, but 'SCSI disk support' may"
> +comment "also be needed; see USB_STORAGE Help for more information"
> +
>  config USB_STORAGE_DEBUG

Better ... but wouldn't something like

	comment "You probably also need to enable 'SCSI disk support'"
		depends on !BLK_DEV_SD

be better?  No point in telling people stuff they don't need to know...
