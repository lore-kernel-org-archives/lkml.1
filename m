Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbZFNXgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbZFNXgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFNXgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:36:25 -0400
Received: from web31702.mail.mud.yahoo.com ([68.142.201.182]:31978 "HELO
	web31702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752753AbZFNXgZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:36:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=TUpH7fYC+kMxe/Mr6yhXmlFjDILnqlJo7RxqpPwpCC5SWzpkVCO56Ooy7dtaaALARt8dommV/Z4AewzheScSvcPH+RIGVwgXmkecaH/csPSwrpKntesczEN/QFKgesOstBt/Qa0GiA5OHERtMvrtO0hFmOSHxiuiyMxOvRwnjow=;
Message-ID: <493605.36824.qm@web31702.mail.mud.yahoo.com>
X-YMail-OSG: hc41AtgVM1k.yATTEQoy28Z3y7uZ8AymaOae_TWxG_D9kVIKt_hIBNXBs1uYW_s4d.sEWEwJyIRDMSgby.J5gKTjnozV6eECTcDv2VVryBSdyiZUdmyaML7kWePj3naAo2THRLImlIOXQVamN0XMJEH.F6YFyugme_t1lYlvfZ0jWp440FIG5rIhiAF3ytk.XAsixswPhj0X6dVtmtTmcWGUPwL89FHhnYSHV6AaoXveqT3qhESEl4ep3hYyqLxyEOoeBy_uV8p0L0AVyTG6XB2WFoNnSNgIpooLZBxePjhB72MwSsnfHHCU1BbEC_jWFoJfDzezUtNoM_pDDhVgfZ761Bje4lU2.45A7TI_VNd6v3xzJbxSFqPc.yhsyo7b
X-Mailer: YahooMailRC/1357.18 YahooMailWebService/0.7.289.15
References: <233030.36441.qm@web31706.mail.mud.yahoo.com>  <4A333E0D.8050306@gmail.com>  <19209.93239.qm@web31703.mail.mud.yahoo.com> <51f3faa70906140926p2e34cb47j1ad8e9332c893c0d@mail.gmail.com>
Date: Sun, 14 Jun 2009 16:36:27 -0700 (PDT)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: Re: PCIe interface memory memory mapping issue
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <51f3faa70906140926p2e34cb47j1ad8e9332c893c0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




>>>> I have developed a PCI express interface using Xilinx ML555 hardware module. I have implemented Linux kernel >>mode device drivers and everything works correctly as long as I am using the device within a computer with dual >>channel DDR arrangement. However, as soon as I pug this device into a core i7 or an older single channel DDR >>machine, the interface memory mapping does not work any more. As if the register map with in the device does no >>longer exsists. However, "lspci" utility provides correct information. I am not sure if this has anything to do with the >>number of DDR memory channels the motherboard has or why that would be a problem for PCI express device. >>However, this seem to be the common link between the machines that demonstrate this issue.
>>
>>>You'll have to give more details on what you mean by "the interface memory mapping does not work any more. As if >the register map with in the device does no longer exsists".
>>
>> What I mean by this is that, when load the driver, the memory mapping of the hardware memory onto the computer memory does not work. I have a setup where I have all the control registers in BAR5 (512 byte) and I also have 64kB chuck of the FPGA memory mapped using BAR0. I am not able to see the register space when the BAR5 area in the computer memory map. However, I am able to write something to BAR0 memory map and read it back.

>How are you getting the register space into the memory map.. ioremap() ?

that's right! I am using  ioremap(address, size). 



      Need a Holiday? Win a $10,000 Holiday of your choice. Enter now.http://us.lrd.yahoo.com/_ylc=X3oDMTJxN2x2ZmNpBF9zAzIwMjM2MTY2MTMEdG1fZG1lY2gDVGV4dCBMaW5rBHRtX2xuawNVMTEwMzk3NwR0bV9uZXQDWWFob28hBHRtX3BvcwN0YWdsaW5lBHRtX3BwdHkDYXVueg--/SIG=14600t3ni/**http%3A//au.rd.yahoo.com/mail/tagline/creativeholidays/*http%3A//au.docs.yahoo.com/homepageset/%3Fp1=other%26p2=au%26p3=mailtagline
