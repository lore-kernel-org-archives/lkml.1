Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbYLUSI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbYLUSI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 13:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYLUSIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 13:08:49 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:35839 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYLUSIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 13:08:47 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=g2PyBXxv-yOW-mcmQY8A:9 a=kuo3R06hMVIN4QMCrSnTygOHVQkA:4 a=Z83RVPqIg3kA:10 a=Fb5YnIP1Z60A:10
Message-ID: <494E862D.5030309@shaw.ca>
Date: Sun, 21 Dec 2008 12:08:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Alessandro Bono <alessandro.bono@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with thermal control: ACPI: Critical trip point - Critical
 temperature reached  - shutting down.
References: <gigib1$fbj$1@ger.gmane.org> <494C8B5B.8020606@shaw.ca> <1229770623.8215.82.camel@champagne.cantina>
In-Reply-To: <1229770623.8215.82.camel@champagne.cantina>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Bono wrote:
> On Sat, 2008-12-20 at 00:06 -0600, Robert Hancock wrote:
> 
> [...]
> 
>> Are the fan(s) running? What does /proc/acpi/fan/*/* show?
> 
> yes fans are running and on load system become noisy

..
> and on full load 
> 
> 
> sandro@champagne:~$ acpi -V        
>      Battery 0: Full, 96%          
>   AC Adapter 0: on-line            
>      Thermal 0: ok, 101.0 degrees C
>      Thermal 1: ok, 85.0 degrees C 
>      Thermal 2: ok, 100.0 degrees C
>      Thermal 3: ok, 30.1 degrees C 
>      Thermal 4: ok, 65.0 degrees C 
>      Thermal 5: ok, 79.0 degrees C 
>      Cooling 0: LCD 0 of 10        
>      Cooling 1: Processor 0 of 10  
>      Cooling 2: Processor 0 of 10  
>      Cooling 3: Fan 1 of 1         
>      Cooling 4: Fan 1 of 1         
>      Cooling 5: Fan 1 of 1         
>      Cooling 6: Fan 1 of 1         
>      Cooling 7: Fan 1 of 1         
>      Cooling 8: Fan 0 of 1         
>      Cooling 9: Fan 1 of 1         
>      Cooling 10: Fan 1 of 1        
>      Cooling 11: Fan 1 of 1        
>      Cooling 12: Fan 1 of 1        
>      Cooling 13: Fan 1 of 1        
> sandro@champagne:~$ cat /proc/acpi/thermal_zone/*/*
> <setting not supported>                            
> <polling disabled>                                 
> state:                   active[0]                 
> temperature:             85 C                      
> critical (S5):           256 C                     
> passive:                 100 C: tc1=1 tc2=2 tsp=300 devices=CPU0 CPU1 
> active[0]:               85 C: devices=C387                           
> active[1]:               65 C: devices=C388                           
> active[2]:               60 C: devices=C389                           
> active[3]:               50 C: devices=C38A                           
> active[4]:               35 C: devices=C38B                           
> <setting not supported>                                               
> <polling disabled>                                                    
> state:                   ok                                           
> temperature:             101 C                                        
> critical (S5):           105 C                                        
> <setting not supported>                                               
> <polling disabled>                                                    
> state:                   active[1]                                    
> temperature:             79 C                                         
> critical (S5):           105 C                                        
> active[0]:               100 C: devices=C36F
> active[1]:               70 C: devices=C36A
> active[2]:               60 C: devices=C36B
> active[3]:               55 C: devices=C36C
> active[4]:               45 C: devices=C36D
> active[5]:               35 C: devices=C36E
> <setting not supported>
> <polling disabled>
> state:                   ok
> temperature:             65 C
> critical (S5):           105 C
> passive:                 95 C: tc1=1 tc2=2 tsp=300 devices=CPU0 CPU1
> <setting not supported>
> <polling disabled>
> state:                   ok
> temperature:             30 C
> critical (S5):           105 C
> passive:                 60 C: tc1=1 tc2=2 tsp=300 devices=CPU0 CPU1
> <setting not supported>
> <polling disabled>
> state:                   ok
> temperature:             100 C
> critical (S5):           110 C
> sandro@champagne:~$ cat /proc/acpi/fan/*/*
> status:                  on
> status:                  on
> status:                  on
> status:                  on
> status:                  on
> status:                  off
> status:                  on
> status:                  on
> status:                  on
> status:                  on
> status:                  on

Looks like the fan entries are being commanded pretty much full out.. 
(I'm sure those don't all correspond to physical fans, but likely 
different fan speeds.) Are you sure there's not a hardware problem (one 
or more fans not working, vents/heatsink clogged with dust)? Your system 
seems to be running very hot.
