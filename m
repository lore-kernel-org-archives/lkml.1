Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbYILXqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbYILXqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYILXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:46:13 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:47830 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753696AbYILXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:46:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3MscgELNfmlXT2F/3OQTp2Dh3ySlw7ATtYkSqkVIY59rxDhtDrZblBssMKFQDVwfHorVmPxQ5v/uZwiwmqT9Bnfj2mssyYnNBjFhHav5krXRx2hA0xAQ4oQAp1UittfOb+Rect9GN/tLXAABj7FtPUHHtw4qZBxmXbiBCFG8Hak=  ;
X-YMail-OSG: LMyGwnYVM1mQ7laSWbAZZALCy8w0g9shNAH_gtn6m4EC.othDePpKjKNppxKcia6SjZcnR79qgJYBgamEzISA6sqcHkh2c_dd.taoeJmvA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Date: Fri, 12 Sep 2008 16:46:08 -0700
User-Agent: KMail/1.9.9
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>, me@bobcopeland.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       lcapitulino@mandriva.com.br, draconux@gmail.com,
       dlallement@mandriva.com, pterjan@mandriva.com, axboe@kernel.dk
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org> <200809121807.28345.herton@mandriva.com.br> <20080912163650.0f85a759.akpm@linux-foundation.org>
In-Reply-To: <20080912163650.0f85a759.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809121646.09641.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008, Andrew Morton wrote:
>                         printk(KERN_ERR " %s: p%d exceeds device capacity\n",
>                                 disk->disk_name, p);
> -                       continue;
>                 }

So that now deserves to be KERN_WARN not KERN_ERR, yes?

