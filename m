Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZBSDcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZBSDcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBSDcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:32:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:44533 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZBSDcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:32:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=YveosH1yureh/V/M6L9iHvSVrAPmajKJC/X9KZkUlkk8Se/71x8/4+gWKcH90Lgl4W
         j2625vqSpCqNV0SVXxnWB3BdhyC5szASoFJDPeJNiihZKSs4lhdZ3L9Fo5f0k8CmVwSg
         wLet2qS9uG89y1MMxU+0cYF5bRhUBMsgKD7Mg=
Message-ID: <499CD2B8.8040607@gmail.com>
Date: Wed, 18 Feb 2009 21:32:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Maurice Volaski <mvolaski@aecom.yu.edu>
CC: Eric.Moore@lsi.com, linux-kernel@vger.kernel.org
Subject: Re: mpt fusion driver crashes with LSI22320SE installed and BIOS
 ACPI   turned off
References: <a06240406c5c0e7c3d7fa@[129.98.90.227]>
In-Reply-To: <a06240406c5c0e7c3d7fa@[129.98.90.227]>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maurice Volaski wrote:
> I emailed about this earlier and here's some new info: the crash occurs 
> when ACPI is turned off. It appears that your driver is expecting 
> information from ACPI and if it doesn't get it, it will crash. (This has 
> been posted as bug http://bugzilla.kernel.org/show_bug.cgi?id=12733)
> 
> On a system with a Supermicro X7DWN+ with ACPI turned off, and an 
> LSI22320SE card installed, the mptdriver will crash. Here is the 
> relevant log:

This could very easily be a motherboard bug. Many newer motherboards are 
NOT tested properly with ACPI disabled. Your case could easily be due to 
the board's interrupt routing for certain slots/devices being messed up 
when ACPI is not in use. For this reason it's generally not a good idea 
to try to disable ACPI these days.
