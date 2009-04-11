Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbZDKWj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbZDKWj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 18:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbZDKWjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 18:39:48 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34052 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738AbZDKWjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 18:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=sCK1plPjZ+3nTmq4ERmmgbuk0HKqgXxe+hFzvocnc8mbbMwkAyYUJSpVodpxAz0NSB
         6QKF5iSbHEx8P0K6gmCcvVdrC3tHCTPgD2WLCf9T7RN+WUrKdG1bzn14NPMJKT3aUW/E
         APYzYenmA9k4M7RWxx4lgBi+ulKpe/nYav+TI=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness with hotkeys
Date: Sun, 12 Apr 2009 00:39:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1; KDE/4.2.2; x86_64; ; )
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <49E10684.5090101@gmail.com> <200904120017.37469.a.miskiewicz@gmail.com>
In-Reply-To: <200904120017.37469.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904120039.43908.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 of April 2009, Arkadiusz Miskiewicz wrote:
> On Saturday 11 of April 2009, Niel Lambrechts wrote:
> > Hi there,
> >
> > With latest git kernel, I'm no longer able to control my Thinkpad (W500)
> > brightness, although I can still control the backlight, bluetooth etc.
>
> Same problem here (but no warning) on T400. I wasn't able to get it
> working. Tried using different values (0, 1,2, 3) for brightness_mode
> without success.

The more interesting is that brightness control starts working after I suspend 
to ram and resume.

Possibly related line logged after resume:
[ 8579.660535] ACPI: EC: non-query interrupt received, switching to interrupt 
mode
-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

