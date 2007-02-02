Return-Path: <linux-kernel-owner+w=401wt.eu-S1423205AbXBBHnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423205AbXBBHnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423209AbXBBHnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:43:45 -0500
Received: from mailout1.vmware.com ([65.113.40.130]:41369 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423205AbXBBHno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:43:44 -0500
Message-ID: <45C2EBAE.7070600@vmware.com>
Date: Thu, 01 Feb 2007 23:43:42 -0800
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3)
MIME-Version: 1.0
To: "Philippe Dhont (Sea-ro)" <philippe.dhont@searo.be>
CC: linux-kernel@vger.kernel.org
Subject: Re: C header files for vmware
References: <EB998357DB660742877807C9BD7D251B9BD2E8@SRVR1.searo.local>
In-Reply-To: <EB998357DB660742877807C9BD7D251B9BD2E8@SRVR1.searo.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2007 07:43:42.0693 (UTC) FILETIME=[DC860950:01C7469D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe Dhont (Sea-ro) wrote:
> hello,
>  
> i downloaded latest kernel 2.6.19.2 and installed it and it works fine.
> Now i am trying to install vmware and it asks the location of the
> directory of the C header files.
> So i pointed it to my download/install directory 
> /data/kernel/2.6.19.2/linux-2.6.19.2/include/
>  
> and i get the error that the directory of kernel headers does not match
> my running kernel ??
> what am i doing wrong ?
> do i need to download something else ?

Error message most probably also contains additional details...

There may be couple of reasons - one of them may be that your product is 
too old to run on 2.6.19.2 kernel without additional changes.  You 
should discuss these issues on http://www.vmware.com/community/index.jspa.

If you are quite sure that you've built your kernel from these sources, 
and you did not run 'make clean' (or make *config) after build kernel, 
then you most probably have to download 
http://knihovny.cvut.cz/ftp/pub/vmware/vmware-any-any-update107.tar.gz, 
untar/ungzip it, run runme.pl from package, and follow directions...  It 
should work with all released Linux products.  If you are using 
Workstation 6.0 beta, you should contact VMware beta support.
							Petr

