Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbXBTLi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbXBTLi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932901AbXBTLi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:38:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6282 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbXBTLiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:38:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=FQ6b0NWqXQS5CfFJ+McGTXYJY+i1QhBX61MiSrs0Pr1rXEsXw8BFGmi0JH12WXGBNIjOOOfilooWbC8UFPyRju0iiM25RMG4+oTjnH7H9RIILyptT4T67iAQaed2Cxdl5kyWmchkqp5VmlPTKYEdeSbg4PqjCQidMYDGAmO0dwM=
Message-ID: <45DADDA8.3000405@gmail.com>
Date: Tue, 20 Feb 2007 12:38:16 +0100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm2
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms000605080406060402040304"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms000605080406060402040304
Content-Type: multipart/mixed;
 boundary="------------080003020701080602080706"

This is a multi-part message in MIME format.
--------------080003020701080602080706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Feb 20 12:18:35 maciek kernel: [ 1443.641949] BUG: unable to handle
kernel NULL pointer dereference at virtual address 0000003e
Feb 20 12:18:35 maciek kernel: [ 1443.641974]  printing eip:
Feb 20 12:18:35 maciek kernel: [ 1443.641980] c01ede81
Feb 20 12:18:35 maciek kernel: [ 1443.641984] *pde = 00000000
Feb 20 12:18:35 maciek kernel: [ 1443.641996] Oops: 0000 [#1]
Feb 20 12:18:35 maciek kernel: [ 1443.642000] PREEMPT
Feb 20 12:18:35 maciek kernel: [ 1443.642008] last sysfs file:
/class/i2c-adapter/i2c-9191/9191-6000/temp3_max
Feb 20 12:18:35 maciek kernel: [ 1443.642016] Modules linked in:
xt_tcpudp xt_limit xt_state iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nfnetlink iptable_filter ip_tables x_tables fuse ppdev lp
thermal fan button processor ac battery tun ipv6 eeprom i2c_viapro
usbhid snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq
8250_pnp 8250 serial_core uhci_hcd snd_via82xx gameport snd_ac97_codec
ide_cd cdrom ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer
snd_page_alloc snd_mpu401_uart shpchp pci_hotplug snd_rawmidi
snd_seq_device via686a snd i2c_isa via_agp soundcore 8139cp 8139too mii
i2c_core usbcore agpgart parport_pc parport evdev unix
Feb 20 12:18:36 maciek kernel: [ 1443.642136] CPU:    0
Feb 20 12:18:36 maciek kernel: [ 1443.642139] EIP:    0060:[<c01ede81>]
   Not tainted VLI
Feb 20 12:18:36 maciek kernel: [ 1443.642144] EFLAGS: 00010297
(2.6.20-mm2 #1)
Feb 20 12:18:36 maciek kernel: [ 1443.642172] EIP is at
__make_request+0x141/0x390
Feb 20 12:18:36 maciek kernel: [ 1443.642182] eax: ffffffff   ebx:
0000003a   ecx: 01291753   edx: 00010485
Feb 20 12:18:36 maciek kernel: [ 1443.642192] esi: dbfb62a0   edi:
dbc781f8   ebp: dbc61844   esp: dbf9dd10
Feb 20 12:18:36 maciek kernel: [ 1443.642201] ds: 007b   es: 007b   fs:
00d8  gs: 0000  ss: 0068
Feb 20 12:18:36 maciek kernel: [ 1443.642212] Process pdflush (pid: 113,
ti=dbf9c000 task=dbf82580 task.ti=dbf9c000)
Feb 20 12:18:36 maciek kernel: [ 1443.642218] Stack: 00000001 dbc781e4
dbfb62a0 d6830b74 dbc61844 dbfb62a0 00000008 00000100
Feb 20 12:18:36 maciek kernel: [ 1443.642238]        c01eb77b dbfd03e0
c13fd9e0 00000000 c014e690 00000008 00000000 00000000
Feb 20 12:18:36 maciek kernel: [ 1443.642256]        00000046 00000292
dbfe6860 00011200 dbfd02f8 00000292 00000008 dbfb62a0
Feb 20 12:18:36 maciek kernel: [ 1443.642274] Call Trace:
Feb 20 12:18:36 maciek kernel: [ 1443.642291]  [<c01eb77b>]
generic_make_request+0x14b/0x1f0
Feb 20 12:18:36 maciek kernel: [ 1443.642309]  [<c014e690>]
handle_level_irq+0xb0/0x120
Feb 20 12:18:36 maciek kernel: [ 1443.642346]  [<c01eda58>]
submit_bio+0x68/0x100
Feb 20 12:18:36 maciek kernel: [ 1443.642368]  [<c019b381>]
bio_alloc_bioset+0x81/0x160
Feb 20 12:18:36 maciek kernel: [ 1443.642393]  [<c0197e09>]
submit_bh+0xb9/0x100



=================================================


Feb 20 12:19:07 maciek kernel: [ 1475.055159] BUG: unable to handle
kernel NULL pointer dereference at virtual address 00000004
Feb 20 12:19:07 maciek kernel: [ 1475.064380]  printing eip:
Feb 20 12:19:07 maciek kernel: [ 1475.100792] c01ede81
Feb 20 12:19:07 maciek kernel: [ 1475.109234] *pde = 00000000
Feb 20 12:19:07 maciek kernel: [ 1475.117432] Oops: 0000 [#2]
Feb 20 12:19:07 maciek kernel: [ 1475.125573] PREEMPT
Feb 20 12:19:07 maciek kernel: [ 1475.133589] last sysfs file:
/class/i2c-adapter/i2c-9191/9191-6000/temp3_max
Feb 20 12:19:07 maciek kernel: [ 1475.141953] Modules linked in:
xt_tcpudp xt_limit xt_state iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nfnetlink iptable_filter ip_tables x_tables fuse ppdev lp
thermal fan button processor ac battery tun ipv6 eeprom i2c_viapro
usbhid snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq
8250_pnp 8250 serial_core uhci_hcd snd_via82xx gameport snd_ac97_codec
ide_cd cdrom ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer
snd_page_alloc snd_mpu401_uart shpchp pci_hotplug snd_rawmidi
snd_seq_device via686a snd i2c_isa via_agp soundcore 8139cp 8139too mii
i2c_core usbcore agpgart parport_pc parport evdev unix
Feb 20 12:19:07 maciek kernel: [ 1475.188714] CPU:    0
Feb 20 12:19:08 maciek kernel: [ 1475.188718] EIP:    0060:[<c01ede81>]
   Not tainted VLI
Feb 20 12:19:08 maciek kernel: [ 1475.188722] EFLAGS: 00010297
(2.6.20-mm2 #1)
Feb 20 12:19:08 maciek kernel: [ 1475.217051] EIP is at
__make_request+0x141/0x390
Feb 20 12:19:08 maciek kernel: [ 1475.226423] eax: ffffffff   ebx:
00000000   ecx: 016d4643   edx: 00000000
Feb 20 12:19:08 maciek kernel: [ 1475.235950] esi: d6307d20   edi:
dbc78978   ebp: dbc61844   esp: d5e09c7c
Feb 20 12:19:08 maciek kernel: [ 1475.245535] ds: 007b   es: 007b   fs:
00d8  gs: 0033  ss: 0068
Feb 20 12:19:08 maciek kernel: [ 1475.255156] Process kde-config (pid:
4675, ti=d5e08000 task=d6843a70 task.ti=d5e08000)
Feb 20 12:19:08 maciek kernel: [ 1475.255504] Stack: 00000000 dbc78964
d6307d20 d6f89494 dbc61844 d6307d20 00000008 00000100
Feb 20 12:19:08 maciek kernel: [ 1475.265489]        c01eb77b 00000004
d5e979d0 0014718f 00000000 00000008 00150613 d62b8788
Feb 20 12:19:08 maciek kernel: [ 1475.275565]        0e55b540 00000141
00000292 00000020 000112d0 dbfd0200 00000008 00000001
Feb 20 12:19:08 maciek kernel: [ 1475.285734] Call Trace:
Feb 20 12:19:08 maciek kernel: [ 1475.305600]  [<c01eb77b>]
generic_make_request+0x14b/0x1f0
Feb 20 12:19:08 maciek kernel: [ 1475.315898]  [<c01eda58>]
submit_bio+0x68/0x100
Feb 20 12:19:08 maciek kernel: [ 1475.326136]  [<c01083c5>]
timer_interrupt+0x15/0x70
Feb 20 12:19:08 maciek kernel: [ 1475.336399]  [<c01bc8e4>]
ext3_get_block+0x74/0xf0
Feb 20 12:19:08 maciek kernel: [ 1475.346682]  [<c019fc70>]
mpage_end_io_read+0x0/0x80
Feb 20 12:19:08 maciek kernel: [ 1475.356972]  [<c019f059>]
mpage_bio_submit+0x19/0x20
Feb 20 12:19:08 maciek kernel: [ 1475.367186]  [<c019f97f>]
do_mpage_readpage+0x2ff/0x590
Feb 20 12:19:08 maciek kernel: [ 1475.377406]  [<c01bc870>]
ext3_get_block+0x0/0xf0
Feb 20 12:19:08 maciek kernel: [ 1475.387622]  [<c0154720>]
add_to_page_cache+0x80/0xe0
Feb 20 12:19:08 maciek kernel: [ 1475.397869]  [<c019fde5>]
mpage_readpages+0x85/0x140
Feb 20 12:19:08 maciek kernel: [ 1475.408076]  [<c01bc870>]
ext3_get_block+0x0/0xf0
Feb 20 12:19:08 maciek kernel: [ 1475.418323]  [<c01bbb00>]
ext3_readpages+0x0/0x20
Feb 20 12:19:08 maciek kernel: [ 1475.428458]  [<c015bab2>]
__do_page_cache_readahead+0x1e2/0x2e0
Feb 20 12:19:08 maciek kernel: [ 1475.438670]  [<c01bc870>]
ext3_get_block+0x0/0xf0
Feb 20 12:19:08 maciek kernel: [ 1475.448927]  [<c015975a>]
get_page_from_freelist+0x2aa/0x3f0
Feb 20 12:19:08 maciek kernel: [ 1475.459262]  [<c0126df1>]
getnstimeofday+0x31/0xc0
Feb 20 12:19:08 maciek kernel: [ 1475.469631]  [<c013b743>]
futex_wake+0xb3/0xd0
Feb 20 12:19:08 maciek kernel: [ 1475.480042]  [<c015c8dc>]
do_page_cache_readahead+0x4c/0x70
Feb 20 12:19:08 maciek kernel: [ 1475.490581]  [<c01571c6>]
filemap_nopage+0x266/0x4e0
Feb 20 12:19:08 maciek kernel: [ 1475.501123]  [<c0162c6d>]
__handle_mm_fault+0x11d/0x970
Feb 20 12:19:08 maciek kernel: [ 1475.511672]  [<c0106a6b>] do_IRQ+0x4b/0x80
Feb 20 12:19:08 maciek kernel: [ 1475.522070]  [<c0116e7e>]
do_page_fault+0x11e/0x5f0
Feb 20 12:19:08 maciek kernel: [ 1475.532247]  [<c014f232>]
__rcu_process_callbacks+0x182/0x1b0
Feb 20 12:19:08 maciek kernel: [ 1475.542182]  [<c0116d60>]
do_page_fault+0x0/0x5f0
Feb 20 12:19:08 maciek kernel: [ 1475.551834]  [<c02fc724>]
error_code+0x74/0x7c
Feb 20 12:19:08 maciek kernel: [ 1475.561368]  =======================
Feb 20 12:19:08 maciek kernel: [ 1475.570866] Code: 31 c0 5b 5e 5f 5d c3
8b 58 18 8b 43 04 8d 44 20 00 8b 7c 24 04 83 c7 14 39 fb 75 1e e9 23 ff
ff ff 48 0f 84 d5 00 00 00 8b 5b 04 <8b> 43 04 8d 44 20 00 39 fb 0f 84
0a ff ff ff 89 f2 89 d8 e8 b7
Feb 20 12:19:08 maciek kernel: [ 1475.591783] EIP: [<c01ede81>]
__make_request+0x141/0x390 SS:ESP 0068:d5e09c7c

-- 
Maciej Rutecki <maciej.rutecki@gmail.com>

--------------080003020701080602080706
Content-Type: application/x-gzip;
 name="config-2.6.20-mm2.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config-2.6.20-mm2.gz"

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
WG8rdGEYGbOSobL9H8G9Atu40QAA
--------------080003020701080602080706--

--------------ms000605080406060402040304
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJHzCC
AuowggJToAMCAQICEE6xoJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgyODEyMzAwNloX
DTA3MDgyODEyMzAwNlowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUG
CSqGSIb3DQEJARYYbWFjaWVqLnJ1dGVja2lAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAxmrZ/vMNBQsTG+9oNg9WeFTNtluscxhg5oBwudmsZhsoDdtQYPlK
ZsRSZnkKTdEWR9w8dwi0JBxmq1XHumBA6/rFfAfhbOV1SBH3ktZ9foamMjpJTjO3+3gF9ocT
wj1GzfReeGZuPgr4qVVvOT5FfD/PkAJzvur7fyLnviiZokQz8R3c+VhJlW3HurhlOlK0ItUu
UuVtCdJosQRepYdPQ6H3Mvn74UxVttDeVxWNlQ2DaS7cy8wTmtc5CTNMVctbJkzFz0a/7wCJ
JHdmqKTgjMBm+ry/IC50jvwkLKAumSJBLWhoIB+LxkJlMwgn69jc0KJkrdkpsUjPdo+zDgff
iQIDAQABozUwMzAjBgNVHREEHDAagRhtYWNpZWoucnV0ZWNraUBnbWFpbC5jb20wDAYDVR0T
AQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQC2O4xAuM7DplCDsgJuaMKz3uR25rq9ucMqVtCW
CAfCyORrFaxN8LFF9KcYx6M4AK1fQ36JVPtMER2VzGMF74gXgrFQ4A9tno6rKzi/QpzwWoPE
4I1hcOKz/YxOK0sRjSDR3p5s2XrKVxgUe+TEeJ6/y1iv52o41oYVmilsUovvHzCCAuowggJT
oAMCAQICEE6xoJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgyODEyMzAwNloXDTA3MDgy
ODEyMzAwNlowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUGCSqGSIb3
DQEJARYYbWFjaWVqLnJ1dGVja2lAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxmrZ/vMNBQsTG+9oNg9WeFTNtluscxhg5oBwudmsZhsoDdtQYPlKZsRSZnkK
TdEWR9w8dwi0JBxmq1XHumBA6/rFfAfhbOV1SBH3ktZ9foamMjpJTjO3+3gF9ocTwj1GzfRe
eGZuPgr4qVVvOT5FfD/PkAJzvur7fyLnviiZokQz8R3c+VhJlW3HurhlOlK0ItUuUuVtCdJo
sQRepYdPQ6H3Mvn74UxVttDeVxWNlQ2DaS7cy8wTmtc5CTNMVctbJkzFz0a/7wCJJHdmqKTg
jMBm+ry/IC50jvwkLKAumSJBLWhoIB+LxkJlMwgn69jc0KJkrdkpsUjPdo+zDgffiQIDAQAB
ozUwMzAjBgNVHREEHDAagRhtYWNpZWoucnV0ZWNraUBnbWFpbC5jb20wDAYDVR0TAQH/BAIw
ADANBgkqhkiG9w0BAQUFAAOBgQC2O4xAuM7DplCDsgJuaMKz3uR25rq9ucMqVtCWCAfCyORr
FaxN8LFF9KcYx6M4AK1fQ36JVPtMER2VzGMF74gXgrFQ4A9tno6rKzi/QpzwWoPE4I1hcOKz
/YxOK0sRjSDR3p5s2XrKVxgUe+TEeJ6/y1iv52o41oYVmilsUovvHzCCAz8wggKooAMCAQIC
AQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENh
cGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAm
BgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1h
aWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNV
BAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQD
EyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEF
AAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B
1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79A
gAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8E
CDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3
dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEa
MBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7M
DaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUa
C4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk1
3iSx0x1G/11fZU8xggNkMIIDYAIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQQIQTrGgkxzJbnibsa3oUSMXezAJBgUrDgMCGgUAoIIBwzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzAyMjAxMTM4MTZaMCMG
CSqGSIb3DQEJBDEWBBTZ+t53Ss57/OPn46e9WxQ5d6Df6TBSBgkqhkiG9w0BCQ8xRTBDMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6xoJMcyW54m7Gt6FEjF3swgYcGCyqGSIb3DQEJEAIL
MXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6x
oJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEBBQAEggEAiCv+SHtFODtC6TAsvcJkFG0/uC8Z
eBAscibh5L2fhjEqNF6fCV8u60IY4+AsXCHNL8WjSmUUF944NBNOXJlAfz2k3wYgQ/c3XjKb
wAX09fo0b3s8K2DLdEKUadKmXQE67Wg2Up+vtAlEJFy9mTzxjd3kDf5AJr31f44umXnlkkJA
di7PGV3v9UTUUQrzr3uD0DgvJEa9uP/vi6hPo6a28dVsEV5WzB4yluFmRJpjTCyO3iJHVFif
w4IRezmd72+b7UgC5ca9l9n1GnMlGW7j3wA27byIVja5d3Q3yHhzPJy0DZl0lqJdScvZ/md6
J3j8ybCOEsH/HE8mb8wPTO63agAAAAAAAA==
--------------ms000605080406060402040304--
