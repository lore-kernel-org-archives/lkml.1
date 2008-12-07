Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYLGROM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYLGROM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYLGRN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:13:56 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:33341 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYLGRNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:13:55 -0500
Date: Sun, 07 Dec 2008 18:13:52 +0100
Message-Id: <534120846@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: odd habits with binary blobs.....
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18P4q/7nH/rk5fWsMefC/ukenrd4ZFqq0BMEjvxWnLGwzgbS
 z12S4ZSIIVXgCribeNc2U3fM/InDUx0cUTF5OB/EtGpNpSmlhI=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>On Wed 2008-12-03 22:40:51, devzero@web.de wrote:
>> hello, 
>> 
>> i gave r1soft`s new/free "hot copy" a try today and .... failed:
>> 
>> vserver2:/tmp/usr/sbin # ./hcp-setup
>> Gathering kernel information
>> Gathering kernel information complete.
>> Error: A network error occurred connecting to 'kmod32.r1soft.com'
>> 
>> what a pain....trying to setup a linux kernel module, the installer wants to phone \
>> home - and fails. 
>> but it`s even worse - http://wiki.r1soft.com/display/LTR1D/hcp-setup tells:
>> 
>> BUILDING HOT COPY DRIVER FROM SOURCE
>> 
>> hcp-setup will tar up your kernel source tree or headers and upload them to an \
>> R1Soft build server over HTTPS using XML-RPC. Once your system's kernel headers or \
>> source have been uploaded the R1Soft build server will compile a Hot Copy device \
>> driver as a kernel module and hcp-setup will automatically download it to your \
>> system. 
>> In order for hcp-setup to work your Linux server must have HTTPS Internet access to \
>> kmod32.r1soft.com (32-bit systems) and kmod64.r1soft.com (64-bit systems) 
>> 
>> how weird is THAT?
>> 
>> did anybody ever come across such "build binary blobs remotely" system ?
>> 
>> 
>> ok, disqualified.  won`t touch it again, as i also don`t know what REALLY is \
>> transferred to the vendor - but i wonder what kernel devs think about such build \
>> system and what in-kernel alternative exists for this. (i think it doesn`t exist - \
>> but maybe somebody working on that ?) 

>Hmm. Gcc was not really designed to prevent .c source from exploiting
>it.
>
>So I guess you could have some phun :-).
>
>									Pavel

I already thought of that.
but isn`t it that not just a matter of gcc exploitability ?
what about uploading specially crafted makefiles, setup-scripts or kernel-source 
containing backdoors.....?

besides hacking into the build servers - the problem i see is that other users download 
binary code from a such potentially compromised system and/or may download kernel-
modules which could (!?) contain binary code compiled from untrusted sourcecode....
maybe BugTraq ML is a better place to discuss.....

roland
_______________________________________________________________________
Sensationsangebot verlängert: WEB.DE FreeDSL - Telefonanschluss + DSL
für nur 16,37 Euro/mtl.!* http://dsl.web.de/?ac=OM.AD.AD008K13805B7069a

