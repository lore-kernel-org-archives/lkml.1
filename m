Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYH2Vcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYH2Vcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbYH2Vcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:32:43 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46330 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbYH2Vcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:32:42 -0400
X-Sasl-enc: QYOhB3SKF3F7Sklc0yqUTLFFfKz8iC0JXr6qA99IDXtW 1220045560
Date: Fri, 29 Aug 2008 18:32:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, toshiba_acpi@memebeam.org, ivdoorn@gmail.com,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth
	togglingthrough rfkill (v7)
Message-ID: <20080829213236.GA27281@khazad-dum.debian.net>
References: <20080829141216.f0d69ae4.akpm@linux-foundation.org> <f86c32a17907fdacd870e853761f0382@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86c32a17907fdacd870e853761f0382@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Philip Langdale wrote:
> On Fri, 29 Aug 2008 14:12:16 -0700, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > ERROR: "rfkill_force_state" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_free" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_register" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_allocate" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_unregister" [drivers/acpi/toshiba_acpi.ko] undefined!
> > 
> > I'll stick a `select RFKILL' in there, but it'll probably blow up
> > in other ways.  select usually does.
> 
> Sorry, thanks for catching that. thinkpad_acpi also just does 'select
> RFKILL',

select NET
select RFKILL

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
